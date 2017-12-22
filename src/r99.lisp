(defpackage r99
  (:use :cl :cl-dbi :cl-who :hunchentoot :cl-ppcre))
(in-package :r99)

(defvar *version* "0.4.1")

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

;;postgres
(defun now ()
  (second
   (dbi:fetch (query "select now()::text"))))

(defun password (myid)
  (let ((sql (format nil
                     "select password from users where myid='~a'"
                     myid)))
    (second (dbi:fetch (query sql)))))

(defun answered? (pid)
  (let ((sql (format
              nil
              "select id from answers where myid='~a' and pid='~a'"
              (myid)
              pid)))
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
  (page (:h2 "number of answers")
        (let* ((sql "select myid, count(id) from answers group by myid
  order by myid")
               (results (query sql)))
          (loop for row = (dbi:fetch results)
                while row
                do (format t
                           "<p>~A | ~A</p>"
                           (getf row :|myid|)
                           ;; mysql/postgres で戻りが違う。
                           (stars (getf row :|count|)))))))

(defvar *problems* (dbi:fetch-all
                    (query "select num, detail from problems")))

(define-easy-handler (index-alias :uri "/") ()
  (redirect "/problems"))

(define-easy-handler (problems :uri "/problems") ()
  (let ((results (query "select num, detail from problems")))
    (page (:h2 "problems")
    (:p "番号をクリックして回答提出")
    (loop for row = (dbi:fetch results)
       while row
       do (format t
      "<p><a href='/answer?pid=~a'>~a</a>, ~a</p>~%"
      (getf row :|num|)
      (getf row :|num|)
      (getf row :|detail|))))))

(defun my-answer (pid)
  (let* ((q
          (format
           nil
           "select answer from answers where myid='~a' and pid='~a'"
           (myid) pid))
         (answer (dbi:fetch (query q))))
    (if (null answer) nil
        (getf answer :|answer|))))

;; display myid?
(defun other-answers (pid)
  (let ((q
          (format
           nil
           "select myid, answer from answers where not (myid='~a') and
pid='~a' order by update_at desc limit 5"
           (myid) pid)))
    (query q)))

(defun show-answers (pid)
  (let* ((my (my-answer pid) )
         (others (other-answers pid)))
    (page (:h2 "answers " (str pid))
          (:h3 "your answer")
          (:form :method "post" :action "/update-answer"
                 (:input :type "hidden" :name "pid" :value pid)
                 (:textarea :name "answer"
                            :cols 50 :rows 6 (str (escape my)))
                 (:br)
                 (:input :type "submit" :value "update"))
          (:h3 "other answers")
          (loop for row = (dbi:fetch others)
             while row
             do (format t "<p>~a:<pre>~a</pre></p>"
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

;;
(defun exist? (pid)
  (let ((sql (format
              nil
              "select id from answers where myid='~a' and pid='~a'"
              (myid)
              pid)))
    (not (null (dbi:fetch (query sql))))))

(define-easy-handler (update-answer :uri "/update-answer") (pid answer)
  (update (myid)  pid answer))

(defun update (myid pid answer)
  (let ((sql (format
              nil
              "update answers set answer='~a', update_at=now() where myid='~a' and pid='~a'"
              answer
              myid
              pid)))
    (query sql)
    (redirect "/users")))

(defun insert (myid pid answer)
  (let ((sql (format
              nil
              "insert into answers (myid, pid, answer, update_at)
  values ('~a','~a', '~a', now())"
              myid
              pid
              answer)))
    (query sql)
    (redirect "/users")))


(defun upsert (myid pid answer)
  (if (exist? pid)
      (update myid pid answer)
      (insert myid pid answer)))

(defun escape (string)
  (regex-replace-all "<" string "&lt;"))

(define-easy-handler (submit :uri "/submit") (pid answer)
  (if (myid)
      (progn
        (upsert (myid) pid answer)
        (redirect "/users"))
      (redirect "/login")))

(defun submit-answer (pid)
  (let* ((q (format nil "select detail from problems where id='~a'" pid))
         (p (second (dbi:fetch (query q)))))
    (page (:h2 "submit your answer to")
          (:p (str p))
          (:form :method "post" :action "/submit"
                 (:input :type "hidden" :name "pid" :value pid)
                 (:textarea :name "answer" :rows 10 :cols 50)
                 (:br)
                 (:input :type "submit")))))


(define-easy-handler (answer :uri "/answer") (pid)
  (if (myid)
      (if (answered? pid) (show-answers pid)
          (submit-answer pid))
      (redirect "/login")))
;;;
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
;;  (query "set names utf8")
  (format t "r99-~a started at ~d.~%" *version* port))

(defun stop-server ()
  (stop *server*))

(defun main ()
  (start-server)
  (loop (sleep 60)))
