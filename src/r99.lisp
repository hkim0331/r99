(defpackage r99
  (:use :cl :cl-dbi :cl-who :hunchentoot))
(in-package :r99)

(defvar *db*)
(defvar *http*)
(defvar *port*)

(defun query (query)
  (dbi:with-connection (conn :mysql :database-name *db*)
    (let* ((query (dbi:prepare conn query))
           (answer (dbi:execute query)))
      (dbi:fetch-all answer))))

(defun now ()
  (getf (first (query "select datetime('now','localtime')"))
        :|datetime('now','localtime')|))

(defun auth ()
  (multiple-value-bind (user password) (hunchentoot:authorization)
    (or (and (string= user "hello") (string= password "world"))
        (and (string= user "bin") (string= password "ladyn"))
        (hunchentoot:require-authorization))))

(defvar *navi*
  '(htm
    (:p
     (:a :href "http://robocar.melt.kyutech.ac.jp" "robocar")
     " | "
     (:a :href "http://redmine.melt.kyutech.ac.jp" "redmine")
     " | "
     (:a :href "http://mt.melt.kyutech.ac.jp" "micro twitter")
     " | "
     (:a :href "https://repl.it/languages/scheme" :target "_blank" "repl.it"))))

(defmacro standard-page (&body body)
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
       (:title "Robocar 99")
       (:link :type "text/css" :rel "stylesheet" :href "/r99.css"))
      (:body
       (:div :class "navbar navbar-default navbar-fixed-top"
             (:div :class "container"
                   (:h1 :class "pahe-header hidden-xs" "Robocar 99")
                   (navi)))
       (:div :class "container"
             ,@body
             (:hr)
             (:span "programmed by hkimura, release " (str *version*) "."))))))


;;;

(setf (html-mode) :html5)

(defun publish-static-content ()
  (push (create-static-file-dispatcher-and-handler
         "/robots.txt" "static/robots.txt")  *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/favicon.ico" "static/favicon.ico")  *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/r99.css" "static/r99.css")  *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/r99.html" "static/r99.html") *dispatch-table*))

(defvar *http*)

(defun start-server (&optional (port *port*))
  (publish-static-content)
  (setf *http* (make-instance 'easy-acceptor
                              :address "127.0.0.1"
                              :port port
                              :document-root #p "tmp"))
  (start *http*)
  (format t "r99-~a started at ~d.~%" *version* port))

(defun stop-server ()
  (stop *http*))

(defun main ()
  (start-server)
  (loop (sleep 60)))
