(defpackage r99
  (:use :cl :cl-dbi :cl-who :hunchentoot :cl-ppcre))
(in-package :r99)

(defvar *version* "0.0")
(defvar *host* "localhost")
(defvar *db* "r99")
;;FIXME: getenv?
(defvar *user* "user")
(defvar *password* "pass")
(defvar *myid* nil)

(defvar *http-port* 3030)
(defvar *server* nil)

(defun query (sql)
  (dbi:with-connection
      (conn :mysql
            :host *host*
            :username *user*
            :password *password*
            :database-name *db*)
    (dbi:execute (dbi:prepare conn sql))))

(defun now ()
  (second (dbi:fetch (query "select date_format(now(),'%Y-%m-%d')"))))

;;FIXME: (password NIL) returns NIL
(defun password (myid)
  (let ((sql (format nil
                     "select password from users where myid='~a'"
                     myid)))
    (second (dbi:fetch (query sql)))))

(defun answered? (pid)
  (let ((sql (format
              nil
              "select id from answers where myid='~a' and pid='~a'"
              *myid*
              pid)))
    (dbi:fetch (query sql))))

(defmacro navi ()
  '(htm
    (:p
     (:a :href "http://robocar.melt.kyutech.ac.jp" "robocar")
          " | "
     (:a :href "/problems" "problems")
          " | "
     (:a :href "/users" "answers")
          " | "
     (:a :href "/login" "login"))))

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
             (:p "*myid*:" (str *myid*))
             ,@body
             (:hr)
             (:span "programmed by hkimura, release "
                    (str *version*) "."))))))
;;;
(define-easy-handler (hello :uri "/hello") ()
  (page (:h1 "hello")
        (:p "it is " (str (now)) ". time to eat!")
        (:p (format t "it is ~a using (format t ~~ )." (now)))))

(defun stars-aux (n ret)
  (if (zerop n) ret
    (stars-aux (- n 1) (concatenate 'string ret "*"))))

(defun stars (n)
  (stars-aux n ""))

(define-easy-handler (users :uri "/users") ()
  (page (:h2 "number of answers")
        (let* ((sql "select myid, count(id) from answers group by myid")
               (results (query sql)))
          (loop for row = (dbi:fetch results)
                while row
                do (format t
                           "<p>~A | ~A</p>"
                           (getf row :|myid|)
                           (stars (getf row :|count(id)|)))))))

(define-easy-handler (problems :uri "/problems") ()
  (page (:h2 "problems")
        (:p "番号をクリックして回答提出")
        (let* ((sql "select num, detail from problems")
               (results (query sql)))
          (loop for row = (dbi:fetch results)
             while row
             do (format t
                        "<p><a href='/answer?pid=~a'>~a</a>, ~a</p>"
                        (getf row :|num|)
                        (getf row :|num|)
                        (getf row :|detail|))))))

(defun show-answers (pid)
  (page (:h2 "answers" (str pid)))
  )

(defun auth ()
  (multiple-value-bind (myid pass) (hunchentoot:authorization)
    (if (or *myid*
            (and (not (null myid)) (not (null pass))
                 (string= (password  myid) pass)))
        (progn (setf *myid* myid) t)
        (require-authorization))))

;;FIXME: need private login/logout functions
(define-easy-handler (login :uri "/login") ()
  (and (auth)
       (redirect "/problems")))

;;NG.
(define-easy-handler (logout :uri "/logout") ()
  (setf *myid* nil)
  (redirect "/problems"))

(defun exist? (pid)
  (let* ((sql (format
               nil
               "select id from answers where myid='~a' and pid='~a'"
               *myid*
               pid)))
    (not (null (dbi:fetch (query sql))))))

(defun update (pid answer)
  
  )

(defun insert (pid answer)
  )
(defun upsert (pid answer)
  (if (exist? pid)
      (update pid answer)
      (insert pid answer)))

;; upsert?
(define-easy-handler (submit :uri "/submit") (pid answer)
  (when (auth)
    (upsert pid answer)
    (redirect "/users")))

(defun submit-answer (pid)
  (page (:h2 "please submit your answer to " (str pid))
        (:form :method "post" :action "/submit"
               (:input :type "hidden" :name "pid" :value pid)
               (:textarea :name "answer" :rows 10 :cols 50)
               (:br)
               (:input :type "submit"))))


(define-easy-handler (answer :uri "/answer") (pid)
  (if (answered? pid) (show-answers pid)
      (submit-answer pid)))

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
  (format t "r99-~a started at ~d.~%" *version* port))

(defun stop-server ()
  (stop *server*))

(defun main ()
  (start-server)
  (loop (sleep 60)))
