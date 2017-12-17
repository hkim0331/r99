(defun query (query)
  (dbi:with-connection
      (conn :mysql
            :host "localhost"
            :username "user"
            :password "pass"
            :database-name "r99")
    (let* ((query (dbi:prepare conn query))
           (answer (dbi:execute query)))
      (dbi:fetch-all answer))))

(with-open-file (s "sid-uid-myid-jname.txt")
  (do ((l (read-line s) (read-line s nil 'eof)))
      ((eq l 'eof) nil)
    (format t "~s~%" l)))

