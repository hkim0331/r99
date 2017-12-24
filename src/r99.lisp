(defpackage r99
  (:use :cl :cl-dbi :cl-who :cl-ppcre :cl-fad :hunchentoot))
(in-package :r99)

(defvar *version* "0.6.0")

(defun getenv (name &optional default)
  "Obtains the current value of the POSIX environment variable NAME."
  (declare (type (or string symbol) name))
  (let ((name (string name)))
    (or #+abcl (ext:getenv name)
        #+ccl (ccl:getenv name)
        #+clisp (ext:getenv name)
        #+cmu (unix:unix-getenv name) ; since CMUCL 20b
        #+ecl (si:getenv name)
        #+gcl (si:getenv name)
        #+mkcl (mkcl:getenv name)
        #+sbcl (sb-ext:posix-getenv name)
        default)))

(defvar *db* "r99")
(defvar *host* (or (getenv "R99_HOST") "localhost"))
(defvar *http-port* 3030)
(defvar *password* (or (getenv "R99_PASS") "pass1"))
(defvar *server* nil)
(defvar *user* (or (getenv "R99_USER") "user1"))

(defvar *myid* "r99");; cookie name

(defun query (sql)
  (dbi:with-connection
      (conn :postgres
            :host *host*
            :username *user*
            :password *password*
            :database-name *db*)
    (dbi:execute (dbi:prepare conn sql))))

(defun password (myid)
  (let ((sql (format
              nil
              "select password from users where myid='~a'"
              myid)))
    (second (dbi:fetch (query sql)))))

(defun answered? (num)
  (let ((sql (format
              nil
              "select id from answers where myid='~a' and num='~a'"
              (myid)
              num)))
    (dbi:fetch (query sql))))

(defun myid ()
  (cookie-in *myid*))

(defmacro navi ()
  '(htm
    (:p
     (:a :href "http://robocar.melt.kyutech.ac.jp" "robocar")
     " | "
     (:a :href "/problems" "problems")
     " | "
     (:a :href "/users" "answers")
     " | "
     (:a :href "/status" "status")
     " | "
     (:a :href "/login" "login")
     " / "
     (:a :href "/logout" "logout"))))

(defmacro page (&body body)
  `(with-html-output-to-string
       (*standard-output* nil :prologue t :indent t)
     (:html
      :lang "ja"
      (:head
       (:meta :charset "utf-8")
       (:meta :http-equiv "X-UA-Compatible" :content "IE=edge")
       (:meta
        :name "viewport"
        :content "width=device-width, initial-scale=1.0")
       (:link
        :rel "stylesheet"
        :href "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css"
        :integrity "sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb"
        :crossorigin "anonymous")
       (:title "R99")
       (:link :type "text/css" :rel "stylesheet" :href "/r99.css"))
      (:body
       (:div :class "navbar navbar-default navbar-fixed-top"
             (:div :class "container"
                   (:h1 :class "pahe-header hidden-xs" "R99")
                   (navi)))
       (:div :class "container"
             (:p "myid: " (str (myid)))
             ,@body
             (:hr)
             (:span "programmed by hkimura, release "
                    (str *version*) "."))))))

(defun stars-aux (n ret)
  (if (zerop n) ret
    (stars-aux (- n 1) (concatenate 'string ret "*"))))

(defun stars (n)
  (stars-aux n ""))

(define-easy-handler (users :uri "/users") ()
  (page
    (:h2 "誰が何問解いたか？")
    (let* ((recent
            (dbi:fetch (query "select myid, num, update_at::text from answers order by update_at desc limit 1")))
           (results
            (query "select myid, count(id) from answers group by myid
  order by myid")))
      (htm (:p (format t "myid ~a answered to question ~a at ~a."
                       (getf recent :|myid|)
                       (getf recent :|num|)
                       (getf recent :|update_at|))))
      (loop for row = (dbi:fetch results)
         while row
         do (format t
                    "<pre>~A | ~A</pre>"
                    (getf row :|myid|)
                    ;; mysql/postgres で戻りが違う。
                    (stars (getf row :|count|)))))))

(defvar *problems* (dbi:fetch-all
                    (query "select num, detail from problems")))

(define-easy-handler (index-alias :uri "/") ()
  (redirect "/problems"))

(define-easy-handler (problems :uri "/problems") ()
  (let ((results (query "select num, detail from problems order by num")))
    (page
      (:h2 "problems")
      (:p "番号をクリックして回答提出")
      (loop for row = (dbi:fetch results)
         while row
         do (format t
                    "<p><a href='/answer?num=~a'>~a</a>, ~a</p>~%"
                    (getf row :|num|)
                    (getf row :|num|)
                    (getf row :|detail|))))))

(defun my-answer (num)
  (let* ((q
          (format
           nil
           "select answer from answers where myid='~a' and num='~a'"
           (myid) num))
         (answer (dbi:fetch (query q))))
    (if (null answer) nil
        (getf answer :|answer|))))

(defun other-answers (num)
  (let ((q
          (format
           nil
           "select myid, answer from answers where not (myid='~a') and
num='~a' order by update_at desc limit 5"
           (myid) num)))
    (query q)))

(defun detail (num)
  (let* ((q (format nil "select detail from problems where num='~a'" num))
         (ret (dbi:fetch (query q))))
    (unless (null ret)
      (getf ret :|detail|))))

(defun show-answers (num)
  (let* ((my (my-answer num))
         (others (other-answers num)))
    (page
      (:p (format t "~a, ~a" num (detail num)))
      (:h3 "your answer")
      (:form :class "answer" :method "post" :action "/update-answer"
             (:input :type "hidden" :name "num" :value num)
             (:textarea :name "answer"
                        :cols 60
                        :rows (+ 1 (count #\return my :test #'equal))
                        (str (escape my)))
             (:br)
             (:input :type "submit" :value "update"))
      (:br)
      (:h3 "others")
      (loop for row = (dbi:fetch others)
         while row
         do (format t "<p>~a:<pre class='answer'><code>~a</code></pre></p>"
                    (getf row :|myid|)
                    (escape (getf row :|answer|)))))))

(define-easy-handler (auth :uri "/auth") (id pass)
  (if (or (myid)
          (and (not (null id)) (not (null pass))
               (string= (password  id) pass)))
      (progn
        (set-cookie *myid* :value id :max-age 86400)
        (redirect "/problems"))
      (redirect "/login")))

;;FIXME: need private login/logout functions
(define-easy-handler (login :uri "/login") ()
  (page
    (:h2 "LOGIN")
    (:form :method "post" :action "/auth"
           (:p "myid")
           (:p (:input :type "text" :name "id"))
           (:p "password")
           (:p (:input :type "password" :name "pass"))
           (:p (:input :type "submit" :value "login")))))

(define-easy-handler (logout :uri "/logout") ()
  (set-cookie *myid* :max-age 0)
  (redirect "/problems"))

(defun exist? (num)
  (let ((sql (format
              nil
              "select id from answers where myid='~a' and num='~a'"
              (myid)
              num)))
    (not (null (dbi:fetch (query sql))))))

(define-easy-handler (update-answer :uri "/update-answer") (num answer)
  (if (check answer)
      (update (myid) num answer)
      (page
        (:h3 "error")
        (:p "ビルドできねーよ。"))))

(defun update (myid num answer)
  (let ((sql (format
              nil
              "update answers set answer='~a', update_at=now() where myid='~a' and num='~a'"
              answer
              myid
              num)))
    (query sql)
    (redirect "/users")))

(defun insert (myid num answer)
  (let ((sql (format
              nil
              "insert into answers (myid, num, answer, update_at)
  values ('~a','~a', '~a', now())"
              myid
              num
              answer)))
    (query sql)
    (redirect "/users")))

;; (defun upsert (myid num answer)
;;   (if (exist? num)
;;       (update myid num answer)
;;       (insert myid num answer)))

(defun escape (string)
  (regex-replace-all "<" string "&lt;"))

;; check syntax only.
(defun check (answer)
  (let* ((cl-fad:*default-template* "temp%.c")
         (pathname (with-output-to-temporary-file (f)
                     (write-string answer f)))
         (ret (sb-ext:run-program
               "/usr/bin/cc"
               `("-fsyntax-only" ,(namestring pathname)))))
    (delete-file pathname)
    (= 0 (sb-ext:process-exit-code ret))))

(define-easy-handler (submit :uri "/submit") (num answer)
  (if (myid)
      (if (check answer)
          (progn
            ;; was (upsert (myid) num answer)
            (insert (myid) num answer)
            (redirect "/users"))
          (page
           (:h3 "error")
           (:p "ビルドできません")))
      (redirect "/login")))

(defun submit-answer (num)
  (let* ((q (format nil "select detail from problems where id='~a'" num))
         (p (second (dbi:fetch (query q)))))
    (page
      (:h2 "submit your answer to")
      (:p (str p))
      (:form :method "post" :action "/submit"
             (:input :type "hidden" :name "num" :value num)
             (:textarea :name "answer" :cols 60 :rows 10)
             (:br)
             (:input :type "submit")))))

(define-easy-handler (answer :uri "/answer") (num)
  (if (myid)
      (if (answered? num) (show-answers num)
          (submit-answer num))
      (redirect "/login")))

(defun solved (myid)
    (let* ((q (format nil "select num from answers where myid='~a'"
                      myid))
           (ret (dbi:fetch-all (query q))))
      (mapcar (lambda (x) (getf x :|num|)) ret)))


;;; status
(defun my-password (myid)
  (let* ((q (format
             nil "select password from users where myid='~a'" myid))
         (ret (dbi:fetch (query q))))
    (getf ret :|password|)))

(define-easy-handler (passwd :uri "/passwd") (myid old new1 new2)
  (let ((status "パスワードを変更しました。"))
    (page
      (:h2 "change password")
      (if (string= (my-password myid) old)
          (if (string= new1 new2)
              (query (format nil "update users set password='~a' where myid='~a'" new1 myid))
              (setf status "パスワードが一致しません。"))
          (setf status "現在のパスワードが一致しません"))
      (:p (str status)))))

(define-easy-handler (status :uri "/status") ()
  (if (myid)
      (let ((sv (apply #'vector (solved (myid)))))
        (page
          (:h3 "自分の回答状況")
          (loop for n from 1 to 99 do
               (htm (:a :href (format nil "/answer?num=~a" n)
                        :class (if (find n sv) "found" "not-found")
                        (str n))))
          (:hr)
          (:h3 "パスワード変更")
          (:form :method "post" :action "/passwd"
                 (:p "myid (変更不可)")
                 (:p (:input :type "text" :name "myid" :value (str (myid))
                             :readonly "readonly"))
                 (:p "old password")
                 (:p (:input :type "password" :name "old"))
                 (:p "new password")
                 (:p (:input :type "password" :name "new1"))
                 (:p "new password again (same one)")
                 (:p (:input :type "password" :name "new2"))
                 (:input :type "submit" :value "change"))))
      (redirect "/login")))

;;; start page
(setf (html-mode) :html5)

(defun publish-static-content ()
  (push (create-static-file-dispatcher-and-handler
         "/robots.txt" "static/robots.txt") *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/favicon.ico" "static/favicon.ico") *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/r99.css" "static/r99.css") *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/r99.html" "static/r99.html") *dispatch-table*))

(defun start-server (&optional (port *http-port*))
  (publish-static-content)
  (setf *server* (make-instance 'easy-acceptor
                              :address "127.0.0.1"
                              :port port
                              :document-root #p "tmp"))
  (start *server*)
  (format t "r99-~a started at ~d.~%" *version* port))

(defun stop-server ()
  (stop *server*))

(defun main ()
  (start-server)
  (loop (sleep 60)))
