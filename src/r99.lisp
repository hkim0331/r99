(defpackage r99
  (:use :cl :cl-dbi :cl-who :cl-ppcre :cl-fad :hunchentoot))
(in-package :r99)

(defvar *version* "0.9.4.2")

(defun getenv (name &optional default)
  "Obtains the current value of the POSIX environment variable NAME."
  (declare (type (or string symbol) name))
  (let ((name (string name)))
    (or #+abcl (ext:getenv name)
        #+ccl (ccl:getenv name)
        #+clisp (ext:getenv name)
        #+cmu (unix:unix-getenv name) ; since CMUCL 20b
        #+ecl (si:getenv name)
        #+gcl (si:getenv ame)
        #+mkcl (mkcl:getenv name)
        #+sbcl (sb-ext:posix-getenv name)
        default)))
;;
(defvar *host* (or (getenv "R99_HOST") "localhost"))
(defvar *user* (or (getenv "R99_USER") "user1"))
(defvar *password* (or (getenv "R99_PASS") "pass1"))
(defvar *db* "r99")
;;
(defvar *server* nil)
(defvar *http-port* 3032)
;;
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

;;
(defun myid ()
  (cookie-in *myid*))

;; trim datetme
(defun short (datetime)
  (subseq datetime 0 19))

(defun yyyy-mm-dd (iso)
  (let ((ans (multiple-value-list (decode-universal-time iso))))
    (format
     nil
     "~4,'0d-~2,'0d-~2,'0d"
     (nth 5 ans) (nth 4 ans) (nth 3 ans))))

(defun answered? (num)
  (let ((sql
         (format
          nil
          "select id from answers where myid='~a' and num='~a'"
          (myid)
          num)))
    (dbi:fetch (query sql))))

(defun escape (string)
  (regex-replace-all "<" string "&lt;"))

;; answer から ' をエスケープしないとな。
;; 本来はプリペアドステートメント使って処理するべき。
;; bugfix: 0.8.8
(defun escape-apos (answer)
  (regex-replace-all
   "\\?"
   (regex-replace-all
    "\""
    (regex-replace-all "'" answer "&apos;") "&quot;") "？"))

(defun check (answer)
  (and
   (scan "\\S" answer)
   (let* ((cl-fad:*default-template* "temp%.c")
          (pathname (with-output-to-temporary-file (f)
                      (write-string "#include <stdio.h>" f)
                      (write-char #\Return f)
                      (write-string "#include <stdlib.h>" f)
                      (write-char #\Return f)
                      (write-string answer f)))
          (ret (sb-ext:run-program
                "/usr/bin/cc"
                `("-fsyntax-only" ,(namestring pathname)))))
     (delete-file pathname)
     (= 0 (sb-ext:process-exit-code ret)))))


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
        :href
        "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
        :integrity
        "sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
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

(define-easy-handler (last-answer :uri "/last") (myid)
  (let* ((q
          (format
           nil
           "select num from answers where myid='~a'
 order by update_at desc limit 1"
           myid))
         (ret (dbi:fetch (query q)))
         (num (getf ret :|num|)))
    (redirect (format nil "/answer?num=~a" num))))

(defun count-answers ()
  (getf
   (dbi:fetch (query "select count(*) from answers"))
   :|count|))

;;
;; answers
;;
(define-easy-handler (users-alias :uri "/answers") ()
  (redirect "/users"))

(define-easy-handler (users :uri "/users") ()
  (page
    (:p (:img :src "/guernica.jpg" :width "100%"))
    (:h2 "誰が何問?")
    (let* ((n 0)
           (recent
            (dbi:fetch
             (query "select myid, num, update_at::text from answers
 order by update_at desc limit 1")))
           (results
            (query "select users.myid, users.midterm, count(distinct answer)
 from users
 inner join answers
 on users.myid=answers.myid
 group by users.myid, users.midterm
 order by users.myid"))
           (working-users
             (mapcar (lambda (x) (getf x :|myid|))
                     (dbi:fetch-all
                      (query  "select distinct(myid) from answers
 where now() - update_at < '48 hours'")))))
      (htm (:p (format
                t
                "myid ~a answered to question <a href='/answer?num=~a'>~a</a> at ~a."
                (getf recent :|myid|)
                (getf recent :|num|)
                (getf recent :|num|)
                (short (getf recent :|update_at|))))
           (:p (format
                t
                "<span class='yes'>赤</span>
 は過去 48 時間以内にアップデートがあった受講生。全回答数 ~a。"
                (count-answers)))
           (:hr))
      (loop for row = (dbi:fetch results)
            while row
            do
               (let* ((myid (getf row :|myid|))
                      (working (if (find myid working-users) "yes" "no")))
                 (format
                  t
                  "<pre><span class=~a>~A</span> (~2d) ~A<a href='/last?myid=~d'>~d</a></pre>"
                  working
                  myid
                  (getf row :|midterm|)
                  (stars (getf row :|count|))
                  myid
                  (getf row :|count|)))
           (incf n))
      (htm (:p "受講生 242(+2) 人、一題以上回答者 " (str n) " 人。")))))
;;
;; /problems
;;
(define-easy-handler (index-alias :uri "/") ()
  (redirect "/problems"))

(define-easy-handler (problems :uri "/problems") ()
  (let ((results
         (query
          "select answers.num, count(*), problems.detail from answers
inner join problems on answers.num=problems.num
group by answers.num, problems.detail
order by answers.num")))
    (page
      (:p (:img :src "/a-gift-of-the-sea.jpg" :width "100%"))
      (:h2 "problems")
      (:p "番号をクリックして回答提出。ビルドできない回答は受け取らないよ。(回答数)")
      (loop for row = (dbi:fetch results)
         while row
         do (format
             t
             "<p><a href='/answer?num=~a'>~a</a> (~a) ~a</p>~%"
             (getf row :|num|)
             (getf row :|num|)
             (getf row :|count|)
             (getf row :|detail|))))))

;;
;; add-comment
;;
(define-easy-handler (add-comment :uri "/add-comment") (id comment)
  (let* ((a (dbi:fetch
             (query (format
                     nil
                     "select num, answer from answers where id='~a'"
                     id))))
         (answer (getf a :|answer|))
         (update-answer (format
                         nil
                         "~a~%/* comment from ~a,~%~a~%*/"
                         answer
                         (myid)
                         (escape-apos comment)))
         (q (format
             nil
             "update answers set answer='~a' where id='~a'"
             update-answer
             id)))
    (dbi:fetch (query q))
    (redirect (format nil "/answer?num=~a" (getf a :|num|)))))

(defun detail (num)
  (let* ((q (format
             nil
             "select detail from problems where num='~a'"
             num))
         (ret (dbi:fetch (query q))))
    (unless (null ret)
      (getf ret :|detail|))))

;;
;; comment
;;
(define-easy-handler (comment :uri "/comment") (id)
  (let ((ret
         (dbi:fetch
          (query
           (format
            nil
            "select myid, num, answer from answers where id='~a'" id)))))
    (page
      (:h2 (format
            t
            "Comment to ~a's answer ~a"
            (getf ret :|myid|) (getf ret :|num|)))
      (:p (str (detail (getf ret :|num|))))
      (:pre (str (escape (getf ret :|answer|))))
      (:form :methopd "post" :action "/add-comment"
             (:input :type "hidden" :name "id" :value id)
             (:textarea :rows 5 :cols 50 :name "comment"
                        :placeholder "warm comment please.")
             (:p (:input :type "submit" :value "comment")
                 " (your comment is displayed with your myid)")))))

(defun r99-answer (myid num)
  (let* ((q
          (format
           nil
           "select answer from answers where myid='~a' and num='~a'"
           myid num))
         (answer (dbi:fetch (query q))))
    (if (null answer) nil
        (getf answer :|answer|))))

(defun r99-other-answers (num)
  (query (format
          nil
          "select id, myid, answer, update_at::text from answers
 where not (myid='~a') and not (myid='8000') and not (myid='8001')
 and num='~a'
 order by update_at desc
 limit 5" (myid) num)))

(defun show-answers (num)
  (let ((my-answer (r99-answer (myid) num))
        (other-answers (r99-other-answers num)))
    (page
      (:p (format t "~a, ~a" num (detail num)))
      (:h3 "your answer")
      (:form :class "answer" :method "post" :action "/update-answer"
             (:input :type "hidden" :name "num" :value num)
             (:textarea :name "answer"
                        :cols 60
                        :rows (+ 1 (count #\return my-answer :test #'equal))
                        (str (escape my-answer)))
             (:br)
             (:input :type "submit" :value "update"))
      (:br)
      (:h3 "others")
      (loop for row = (dbi:fetch other-answers)
         while row
         do (format
             t
             "<b>~a</b>
 at ~a,
 <a href='/comment?id=~a'> comment</a>
 <pre class='answer'><code>~a</code></pre><hr>"
             (getf row :|myid|)
             (short (getf row :|update_at|))
             (getf row :|id|)
             (escape (getf row :|answer|))))
      (format
       t
       "<b>nakadouzono:</b><pre class='answer'><code>~a</code></pre><hr>"
       (escape (r99-answer 8001 num)))
      (format
       t
       "<b>hkimura:</b><pre class='answer'><code>~a</code></pre>"
       (escape (r99-answer 8000 num))))))

(defun exist? (num)
  (let ((sql (format
              nil
              "select id from answers where myid='~a' and num='~a'"
              (myid)
              num)))
    (not (null (dbi:fetch (query sql))))))

(defun update (myid num answer)
  (let ((sql (format
              nil
              "update answers set answer='~a', update_at=now()
 where myid='~a' and num='~a'"
              (escape-apos answer)
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
              (escape-apos answer))))
    (query sql)))

(defun submit-answer (num)
  (let* ((q (format
             nil
             "select num, detail from problems where num='~a'"
             num))
         (ret (dbi:fetch (query q)))
         (num (getf ret :|num|))
         (d (getf ret :|detail|)))
    (page
      (:h2 "submit your answer to " (str num))
      (:p (str d))
      (:ul (:li "ビルドできない回答は受け取らない。")
           (:li "回答を受け取ってもそれが正解とは限らない。")
           (:li "submit できたら、他の受講生の回答と自分の回答をよく見比べること。"))
      (:form :method "post" :action "/submit"
             (:input :type "hidden" :name "num" :value num)
             (:textarea :name "answer" :cols 60 :rows 10
                        :placeholder "動作確認、
 correct indentation して、送信するのがルール。
 ケータイで回答もらって平常点インチキしても期末テストで確実に負けるから。
 マジ勉した方がいい。")
             (:br)
             (:input :type "submit")))))

(defun solved (myid)
  (let* ((q (format
             nil
             "select num from answers where myid='~a'"
             myid))
         (ret (dbi:fetch-all (query q))))
    (mapcar (lambda (x) (getf x :|num|)) ret)))
;;;
;;; status
;;;
(defun my-password (myid)
  (let* ((q (format
             nil
             "select password from users where myid='~a'"
             myid))
         (ret (dbi:fetch (query q))))
    (getf ret :|password|)))

(define-easy-handler (auth :uri "/auth") (id pass)
  (if (or (myid)
          (and (not (null id)) (not (null pass))
               (string= (password  id) pass)))
      (progn
        (set-cookie *myid* :value id :max-age 86400)
        (redirect "/problems"))
      (redirect "/login")))

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

(define-easy-handler (update-answer :uri "/update-answer") (num answer)
  (if (check answer)
      (update (myid) num answer)
      (page
        (:h3 "error")
        (:p "ビルドできない。バグ混入？"))))

(define-easy-handler (submit :uri "/submit") (num answer)
  (if (myid)
      (if (check answer)
          (let* ((dummy (insert (myid) num answer))
                 (count (count-answers)))
            (page
             (:h1 "received your answer to " (str num))
             (cond
               ((zerop (mod count 100))
                (htm (:p (:img :src "happiest.png"))
                     (:p "おめでとう!!! 通算 " (str count) " 番目の回答です。")))
               ((zerop (mod count 50))
                (htm (:p (:img :src "happier.png"))
                     (:p "おめでとう!! 通算 " (str count) " 番目の回答です。")))
               ((zerop (mod count 10))
                (htm (:p (:img :src "happy.png"))
                     (:p "おめでとう! 通算 " (str count) " 番目の回答です。")))
               (t (htm (:p "received."))))
             (:p "さらに R99 にはげみましょう。")
             (:ul
              (:li (:a :href "/status" "自分の回答状況")
                   "のチェックのほか、")
              (:li (:a :href (format
                              nil
                              "/answer?num=~a" num)
                       "他ユーザの回答を見る")
                   "ことも勉強になるぞ。")
              (:li "それとも直接 "
                   (:a :href (format
                              nil "/answer?num=~a"
                              (+ 1 (parse-integer num)))
                       "次の問題の回答ページ")
                   "、行く？"))))
          (page
            (:h3 "error")
            (:p "ビルドできない。プログラムにエラーがあるぞ。")))
      (redirect "/login")))

(define-easy-handler (answer :uri "/answer") (num)
  (if (myid)
      (if (answered? num) (show-answers num)
          (submit-answer num))
      (redirect "/login")))

(define-easy-handler (passwd :uri "/passwd") (myid old new1 new2)
  (let ((status "パスワードを変更しました。"))
    (page
      (:h2 "change password")
      (if (string= (my-password myid) old)
          (if (string= new1 new2)
              (query (format
                      nil
                      "update users set password='~a' where myid='~a'"
                      new1 myid))
              (setf status "パスワードが一致しません。"))
          (setf status "現在のパスワードが一致しません"))
      (:p (str status)))))

(define-easy-handler (download :uri "/download") ()
  (if (myid)
      (let ((ret
              (query
               (format
                nil
                "select num, answer from answers
 where myid='~a' order by num"
                (myid)))))
        (page
          (:pre "#include &lt;stdio.h>
#include &lt;stdlib.h>")
          (loop for row = (dbi:fetch ret)
                while row
                do
                   (htm
                    (:pre "//" (str (getf row :|num|)))
                    (:pre (str (escape (getf row :|answer|))))))
          (:pre "int main(void) {
    // 定義した関数の呼び出しをここに。
    return 0;
}")))
      (redirect "/login")))

(defun ranking (id)
  (if (<= 8000 (parse-integer id))
      0
      (let* ((q "select distinct myid, count(myid) from answers
 where not (myid='8000') and not (myid='8001')
 group by myid order by count(myid) desc")
             (ret (query q))
             (n 1))
        (loop for row = (dbi:fetch ret)
           while (and row (not (= (parse-integer id) (getf row :|myid|))))
           do
             (incf n))
        n)))
;;;
;;; status
;;;
(defun cheerup (sc)
  (cond
    ((< 99 sc )
     (list "goku.png" " 期末テストは 100 点取れよ！"))
    ((= 99 sc)
     (list "sakura.png" " 完走おめでとう！100番以降もやってみよう。"))
    ((< 80 sc)
     (list "kame.png" " ゴールはもうちょっと。"))
    ((< 60 sc)
     (list "panda.png" " だいぶがんばってるぞ。"))
    ((< 40 sc)
     (list "cat2.png" " その調子。"))
    ((< 20 sc)
     (list "dog.png" " ペースはつかんだ。"))
    ((< 0 sc)
      (list "fuji.png" " 一歩ずつやる。"))
    (t
     (list "fight.png" " がんばらねーと。"))))

(defun get-num-max ()
  (getf
   (dbi:fetch (query "select max(num) from problems"))
   :|max|))

(defun get-jname (id)
  (getf
   (dbi:fetch
    (query
     (format
      nil
      "select jname from users where myid='~a'"
      id)))
   :|jname|))

(defun get-last ()
  (getf
   (dbi:fetch
    (query "select count(distinct myid) from answers"))
   :|count|))

(define-easy-handler (status :uri "/status") ()
  (if (myid)
      (let* ((num-max (get-num-max))
             (sv (apply #'vector (solved (myid))))
             (sc (length sv))
             (jname (get-jname (myid)))
             (last-runner (get-last))
             (cheer (cheerup sc))
             (image (first cheer))
             (message (second cheer)))
        (page
          (:h3 "回答状況")
          (:p "クリックして問題・回答にジャンプ。")
          (loop for n from 1 to num-max
             do
               (htm (:a :href (format nil "/answer?num=~a" n)
                        :class (if (find n sv) "found" "not-found")
                        (str n))))
          (htm (:p (:img :src image) (str message)))
          (:hr)

          (:h3 "アクティビティ")
          (:p (:a :href "/activity" "activity"))
          (:p "毎日ちょっとずつが実力のもと。一度にたくさんはどうかな？")
          (:hr)

          (:h3 "ランキング")
          (:ul
           (:li "氏名: " (str jname))
           (:li "回答数: " (str sc))
           (:li "ランキング: " (str (ranking (myid))) "位 / 242 人"
               " (最終ランナーは " (str (- last-runner 1)) "位と表示されます)"))
          (:hr)

          (:h3 "自分回答をダウンロード")
          (:p (:a :href "/download" "download"))
          (:p "全回答を問題番号順にコメントも一緒にダウンロードします。")
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

;;
;; activity
;;
(define-easy-handler (activity :uri "/activity") ()
  (let ((res
         (query
          (format
           nil
           "select date(update_at), count(date(update_at))
 from answers where myid='~a'
 group by date(update_at)
 order by date(update_at) desc" (myid)))))
    (page
      (:h2 (str (myid)) " Activity")
      (:hr)
      (loop for row = (dbi:fetch res)
         while row
         do
           (format t "<p>~a ~a</p>"
                   (yyyy-mm-dd  (getf row :|date|))
                   (stars (getf row :|count|))))
      (:p (:a :href "/status" "status") "に戻る"))))

(setf (html-mode) :html5)

(defun publish-static-content ()
  (push (create-static-file-dispatcher-and-handler
         "/robots.txt" "static/robots.txt") *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/favicon.ico" "static/favicon.ico") *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/r99.css" "static/r99.css") *dispatch-table*)
  ;; loop or macro?
  (push (create-static-file-dispatcher-and-handler
         "/fuji.png" "static/fuji.png") *dispatch-table*)

  (push (create-static-file-dispatcher-and-handler
         "/panda.png" "static/panda.png") *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/kame.png" "static/kame.png") *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/dog.png" "static/dog.png") *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/cat2.png" "static/cat2.png") *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/fight.png" "static/fight.png") *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/sakura.png" "static/sakura.png") *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/happy.png" "static/happy.png") *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/happier.png" "static/happier.png") *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/happiest.png" "static/happiest.png") *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/goku.png" "static/goku.png") *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler
         "/guernica.jpg" "static/guernica.jpg") *dispatch-table*)
  (push (create-static-file-dispatcher-and-handler "/a-gift-of-the-sea.jpg" "static/a-gift-of-the-sea.jpg") *dispatch-table*))

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
