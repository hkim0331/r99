(defpackage r99
  (:use :cl :cl-dbi :cl-who :cl-ppcre :cl-fad :hunchentoot))

(in-package :r99)

(defvar *version* "2.44.11")
(defvar *nakadouzono* 2998)
(defvar *hkimura*     2999)

(defvar *server* nil)
(defvar *http-port* 3030)
(defvar *myid* "r99");; cookie name

;; 2021-02-02
(defparameter *how-many-answers* 10)

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

(defvar db-host  (or (getenv "R99_HOST") "localhost"))
(defvar db-user  (or (getenv "R99_USER") "user"))
(defvar db-pass  (or (getenv "R99_PASS") "pass"))
(defvar db "r99")

(defun read-midterm (fname)
  (with-open-file
      (in fname)
    (let ((ret nil))
      (loop for line = (read-line in nil)
            while line do
              (destructuring-bind
                  (f s) (ppcre:split " " line)
                (push (cons (parse-integer f) (parse-integer s)) ret)))
      ret)))

(defparameter *mt*
  (if (probe-file "midterm.txt")
      (read-midterm "midterm.txt")
      nil))

(defun query (sql)
  (dbi:with-connection
      (conn :postgres
            :host db-host
            :username db-user
            :password db-pass
            :database-name db)
    (dbi:execute (dbi:prepare conn sql))))

;; 2020-11-02
(defun localtime ()
  (getf
   (dbi:fetch (query "select localtimestamp::text"))
   :|localtimestamp|))

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

;; fix:[1.23] 2020-01-24
;; 対称的な escape/unescape
(defun escape-apos (answer)
  (let* ((s1 (regex-replace-all "'"   answer "&apos;"))
         (s2 (regex-replace-all "\""  s1     "&quot;"))
         (s3 (regex-replace-all "\\?" s2     "？")))
    s3))

(defun unescape-apos (s)
  (let* ((s1 (regex-replace-all "&quot;" s  "\""))
         (s2 (regex-replace-all "&apos;" s1 "'"))
         (s3 (regex-replace-all "？"     s2 "?")))
    s3))

;; コメントだけ送ってくるやつを弾く。
(defun check (answer)
  (and
   (scan "^/" answer)  ; has comment?
   (scan ";" answer)   ; 回答には ';'が含まれて
   (scan "\\)" answer) ; ')' もないとな。
   (scan "\\}" answer) ; '}' もな。この後、文法チェックする。
   (let* ((cl-fad:*default-template* "temp%.c")
          (pathname (with-output-to-temporary-file (f)
                      (write-string "#include <stdio.h>" f)
                      (write-char #\Return f)
                      (write-string "#include <stdlib.h>" f)
                      (write-char #\Return f)
                      (write-string answer f)))
          (ret (sb-ext:run-program
                "/usr/bin/cc"
                (list "-w" "-fsyntax-only" (namestring pathname)))))
     (delete-file pathname)
     (= 0 (sb-ext:process-exit-code ret)))))

(defmacro navi ()
  '(htm
    (:p
     (:a :href "/problems" "problems")
     " | "
     (:a :href "/others" "users")
     " | "
     (:a :href "/status" "my")
     " | "
     (:a :href "/login" "login")
     " / "
     (:a :href "/logout" "logout")
     " , "
     (:a :href "/signin" "signin")
     "|"
     (:a :href "/readme.html" "readme"))))

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
        :href "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        :integrity "sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
        :crossorigin "anonymous")
       (:title "R99")
       (:link :type "text/css" :rel "stylesheet" :href "/r99.css")
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
                     (str *version*) "."))

        (:script
         :src "https://code.jquery.com/jquery-3.3.1.slim.min.js"
         :integrity "sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
         :crossorigin "anonymous")
        (:script
         :src "https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
         :integrity "sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
         :crossorigin "anonymous")
        (:script
         :src "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
         :integrity "sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
         :crossorigin "anonymous"))))))

(defun stars-aux (n ret)
  ;; (if (zerop n) ret
  ;;   (stars-aux (- n 1) (concatenate 'string ret "*"))))
  (cond
    ((zerop n ) ret)
    ((<= 10 n) (stars-aux (- n 10) (concatenate 'string ret "😃")))
    (t (stars-aux (- n 1) (concatenate 'string ret ".")))))

(defun stars (n)
  (stars-aux n ""))

(define-easy-handler (last-answer :uri "/last") (myid)
  (let* ((q
           (format
            nil
            "select num from answers where myid='~a'
 order by timestamp desc limit 1"
            myid))
         (ret (dbi:fetch (query q)))
         (num (getf ret :|num|)))
    (redirect (format nil "/answer?num=~a" num))))

(defun count-answers ()
  (getf
   (dbi:fetch (query "select count(*) from answers"))
   :|count|))

;; FIXME: how to test
;; 2021-04-15
(define-easy-handler (todays :uri "/todays") ()
  (let* ((q "select myid, num, timestamp::text from answers
             where timestamp > CURRENT_DATE
             order by timestamp desc")
         (ret (dbi:fetch-all (query q))))
    (page
      (loop for row in ret
            do (format t "<p>~a | ~a | <a href='/answer?num=~a'>~a</a></p>"
                       (short (getf row :|timestamp|))
                       (getf row :|myid|)
                       (getf row :|num|)
                       (getf row :|num|))))))

;; /recent or /recent?n=10 2020-11-03
(define-easy-handler (recent :uri "/recent") (n)
  (let* ((nn (or n 10))
         (q (format
             nil
             "select myid,num,timestamp::text from answers
             order by timestamp desc limit '~a'"
             nn))
         (ret (dbi:fetch-all (query q))))
    (page
      (loop for row in ret
            do (format t "<p>~a | ~a | <a href='/answer?num=~a'>~a</a></p>"
                       (short (getf row :|timestamp|))
                       (getf row :|myid|)
                       (getf row :|num|)
                       (getf row :|num|))))))

;;
;; admin
;;

(define-easy-handler (show-old :uri "/show-old") (id)
  (let* ((q (format
             nil
             "select myid,num,answer,timestamp::text from old_answers
             where id='~a'"
             id))
         (ret (dbi:fetch (query q)))
         (myid (getf ret :|myid|))
         (num (getf ret :|num|))
         (q2 (format
              nil
              "select id from answers where myid=~a and num=~a" myid num))
         (ret2 (dbi:fetch (query q2)))
         (oid (getf ret2 :|id|)))
    (page
      (:h3 (str myid) " [" (str num) "]")
      (:p (str (getf ret :|timestamp|)))
      (:pre
       (format t "~a" (escape (getf ret :|answer|))))
      (:p (:a :href (format nil "/comment?id=~a" oid) "comment?"))
      (:p (:a :href "/admin" "back to admin")))))

(defun my-subseq (n s)
  (if (< (length s) n)
      s
      (concatenate 'string (subseq s 0 n) "...")))

(define-easy-handler (admin :uri "/admin") ()
  (let ((myid (myid)))
    (if (and myid (or (= (parse-integer myid) *hkimura*)
                      (= (parse-integer myid) *nakadouzono*)))
        (let ((ret (dbi:fetch-all (query "select id, timestamp::text, myid, num,
             answer from old_answers order by id desc"))))
          (page
            (loop for row in ret
                  do (format
                      t
                      "<p><a href='/show-old?id=~a'>~a</a> [~a] ~a ~a</p>"
                      (getf row :|id|)
                      (subseq (getf row :|timestamp|) 0 19)
                      (getf row :|myid|)
                      (getf row :|num|)
                      ;; fix. 2018-12-08.
                      (my-subseq 60 (getf row :|answer|))))))
        (redirect "/login"))))
;;
;; answers
;;

(define-easy-handler (users-alias :uri "/answers") ()
  (redirect "/others"))

;; FIXME: slow.
(defun work-days (myid)
  (let* ((q (format nil "select count (date(timestamp)) from answers
             where myid=~a group by date(timestamp)" myid))
         (ret (dbi:fetch-all (query q))))
    (length ret)))

(defparameter *top-message*
  (concatenate
   'string
   "追試験終了。<a href='ee-answer.html'>標準回答</a>。"))
;; "日曜で R99 は終了。"
;; "２度目の R99 でまじ力つけた人は数人以上いるだろう。"
;; "コピペで単位だけ取ろうとするヤツは万引きと同じ。"
;; "追試の回答は晒します。一人ひとり、違う問題になる予定。"
;; "落ちて元々と思う時は受験しない方がいい。"))

(define-easy-handler (user-answers :uri "/user-answers") (myid)
  (if (or (string= myid (myid)) (string= "2999" (myid)))
      (let* ((q (format
                 nil
                 "select id, num, answer, timestamp::text
   from answers where myid='~a'
   order by timestamp desc"
                 myid))
             (ret (dbi:fetch-all (query q))))
        (page
          (loop for r in ret
                do
                   (htm (:p "#"
                            (str (getf r :|num|))
                            ", "
                            (str (getf r :|timestamp|)))
                        (:pre   (str (escape (getf r :|answer|))))
                        (:p (:a :href (format
                                       nil
                                       "/comment?id=~a"
                                       (getf r :|id|))
                                :class "btn btn-primary btn-sm"
                                "comment"))
                        (:hr)))))
      (page
        (:p (format t "access restricted.")))))

;; /others
(define-easy-handler (users :uri "/others") ()
  (page
    ;;(:p (:a :href "/grading.html" "grading.html"))
    (:p (format t "your ip ~a is recorded." (real-remote-addr)))
    (:p :class "warn" (str *top-message*))
    ;; (:p (:img :src "/kutsugen.jpg" :width "100%"))
    ;; (:p :align "right" "「屈原」横山大観(1868-1958), 1898.")
    ;; (:p (:img :src "/by-answers.svg" :width "90%"))
    ;; (:p
    ;;  "横軸：回答数、縦軸：回答数答えた人の数。"
    ;;  "グラフは毎朝アップデート。")
    (:h1)
    ;;(:h2 "コピー、丸暗記はムダ")
    (let* ((n 0)
           (recent
             (dbi:fetch
              (query "select myid, num, timestamp::text from answers
   order by timestamp desc limit 1")))
           (results
             (query "select users.myid, count(distinct answer)
   from users
   inner join answers
   on users.myid=answers.myid
   group by users.myid
   order by users.myid"))
           (working-users
             (mapcar (lambda (x) (getf x :|myid|))
                     (dbi:fetch-all
                      (query  "select distinct(myid) from answers
   where now() - timestamp < '48 hours'")))))

      ;; BUG: 回答が一つもないとエラーになる。
      ;;(htm
      ;; (:li
      ;;  (format
      ;;   t
      ;;   "<a href='/recent'>最近の10回答</a>。最新は ~a、全回答数 ~a。"
      ;;   (short (getf recent :|timestamp|))
      ;;   (count-answers)))
      ;; (:li (:a :href "/todays" "本日の回答"))
      ;; ****
      ;; (:li "リストは 48 時間以内にアップデートあったユーザ。"
      ;;      "myid をクリックで自分回答が見える。")
      ;; (:li "スマホの幅でもわかるよう、10題で😃、残りは . とした。")
      ;; ;;(:li "( ) は中間テスト点数。30点満点。NIL は未受験。")
      ;; (:li "一番右は R99 に費やした日数。これと回答数を掛けたルートが追試持ち点(予定)。コメント書いてるのに反応ないのと書き換えて知らんぷりはマイナス。失礼ってこと。")
      ;; (:li "実力つけた人は数人以上いると見る。"
      ;;      "変なことせんでも追試は通るだろうし、今後も明るい。"
      ;;      "懲りなかった人はどこかでまたやらかすやろな。"
      ;;      "もう助けないよ。")
      ;; (:li (:a :href "/recent" "最近の10回答")
      ;;      "と、本日分は"
      ;;      (:a :href "/todays" "こちら") "。")

      ;; (:hr))
      ;; ****
      (loop for row = (dbi:fetch results)
            while row
            do
               (let* ((myid (getf row :|myid|))
                      (working (if (find myid working-users) "yes" "no")))
                 ;; FIXME: ここは 80 cols に収まらない。<pre>で囲んでいるので、
                 ;;        改行できない。
                 (when t ;;(string= working "yes")
                   (format
                    t
                    ;;"<pre><span class=~a><a href='/user-answers?myid=~a'>~A</a></span>(~a) ~A <a href='/last?myid=~d'>~d</a>,~a</pre>"
                    "<pre><span class=~a><a href='/user-answers?myid=~a'>~A</a></span> ~A ~d</pre>"
                    working
                    myid
                    myid
                    ;;(cdr (assoc myid *mt*))
                    (stars (getf row :|count|))
                    ;;myid
                    ;;(getf row :|count|)
                    (work-days myid)))) ;;slow
               ;;(sqrt (* (getf row :|count|) (work-days myid))))))
               (when (< 80 (getf row :|count|))
                 (incf n)))
      (htm (:p "80 題以上 " (str n) " 人。")))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; problems
;;;

(define-easy-handler (index-alias :uri "/") ()
  (redirect "/problems"))

(defun zero_or_num (num)
  (if (null num)
      0
      num))

(define-easy-handler (problems :uri "/problems") ()
  (let ((results
          (dbi:fetch-all
           (query "select num, detail from problems order by num")))
        (answers
          (dbi:fetch-all
           (query "select num, count(*) from answers group by num")))
        (nums (make-hash-table)))
    (loop for row in answers
          do
             (setf (gethash (getf row :|num|) nums) (getf row :|count|)))
    (page
      ;;(:p (:a :href "/grading.html" "grading.html"))
      (:p (format t "your ip ~a is recorded." (real-remote-addr)))
      (:p :class "warn" (str *top-message*))
      ;;(:p (:img :src "/a-gift-of-the-sea.jpg" :width "100%"))
      ;;(:p :align "right" "「海の幸」青木 繁(1882-1911), 1904.")
      ;; (:p (:img :src "/by-numbers.svg" :width "90%"))
      ;; (:p "横軸:問題番号、縦軸:回答数。"
      ;;     "グラフは毎朝アップデート。")
      (:h2 "problems")
      (:ul
       (:li "番号をクリックして回答提出。ビルドできない回答は受け取らない。")
       (:li "上の方で定義した関数を利用する場合、"
            "上の関数定義は回答に含めないでOK。")
       (:li "すべての回答関数の上には"
            "#include &lt;stdio.h> #include &lt;stdlib.h>"
   "があると仮定してよい。"))
      (:hr)
      (loop for row in results
            do
               (let ((num (getf row :|num|)))
                 (format t "<p><a href='/answer?num=~a'>~a</a>(~a) ~a</p>~%"
                         num
                         num
                         (zero_or_num (gethash num nums))
                         (getf row :|detail|)))))))

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

(define-easy-handler (add-comment :uri "/add-comment") (id comment)
  (let* ((a (dbi:fetch
             (query (format
                     nil
                     "select num, answer from answers where id='~a'"
                     id))))
         (answer (getf a :|answer|))
         (update-answer (format
                         nil
                         "~a~%/* comment from ~a at ~a,~%~a~%*/"
                         answer
                         (myid)
                         (short (localtime))
                         (escape-apos comment)))
         (q (format
             nil
             "update answers set answer='~a' where id='~a'"
             update-answer
             id)))
    (dbi:fetch (query q))
    (redirect (format nil "/answer?num=~a" (getf a :|num|)))))

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
      (:pre :class "answer" (str (escape (getf ret :|answer|))))
      (:form :methopd "post" :action "/add-comment"
             (:input :type "hidden" :name "id" :value id)
             (:textarea :rows 5 :cols 50 :name "comment"
                        :placeholder "暖かいコメントをお願いします。")
             (:p (:input :type "submit"
                         :value "comment"
                         :class "btn btn-sm btn-info")
                 " (your comment is displayed with your myid)")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
          "select id, myid, answer, timestamp::text from answers
          where not (myid='~a') and not (myid='8000') and not (myid='8001')
          and num='~a'
          order by timestamp desc
          limit ~a" (myid) num *how-many-answers*)))


(define-easy-handler (old-version :uri "/old-version") (myid num)
  (let* ((q (format
              nil
              "select answer, timestamp::text from old_answers
                where myid='~a' and num='~a'"
              myid
              num))
         (ret (dbi:fetch (query q))))
    (if ret
        (page
          (:h4 (format t "~a, at ~a," num (getf ret :|timestamp|)))
          (:pre (str (escape (getf ret :|answer|))))
          (:p "back to "
              (:a :href (format nil "/answer?num=~a" num)
              "answers")))
        (page
          (:p "no previous versions")
          (:p "back to " (:a :href (format nil "/answer?num=~a" num)
                                    "answers"))))))

(defun show-answers (num)
  (let ((my-answer (r99-answer (myid) num))
        (other-answers (r99-other-answers num)))
    (page
      (:p (format t "~a, ~a" num (detail num)))
      (:h3 "Your Answer")
      (:form :class "answer" :method "post" :action "/update-answer"
             (:input :type "hidden" :name "num" :value num)
             (:textarea :name "answer"
                        :cols 60
                        :rows (+ 1 (count #\linefeed my-answer :test #'equal))
                        (str (unescape-apos my-answer)))
             (:br)
             (:input :type "submit"
                     :value "update"
                     :class "btn btn-sm btn-warning"))
      (:br)
      (:h3 "Other Users' Answers")
      (loop for row = (dbi:fetch other-answers)
            while row
            do (format
                t
                "<b>~a</b> at ~a
          <a href='/comment?id=~a' class='btn btn-sm btn-info'> comment</a>
          <a href='/old-version?myid=~a&num=~a'
                  class='btn btn-sm btn-success'>prev version</a>
          <pre class='answer'><code>~a</code></pre><hr>"
                (getf row :|myid|)
                (short (getf row :|timestamp|))
                (getf row :|id|)
                (getf row :|myid|)
                num
                (escape (getf row :|answer|))))
      (format
       t
       "<b>nakadouzono:</b><pre class='answer'><code>~a</code></pre><hr>"
       (escape (r99-answer *nakadouzono* num)))
      (format
       t
       "<b>hkimura:</b><pre class='answer'><code>~a</code></pre>"
       (escape (r99-answer *hkimura* num))))))

(defun exist? (num)
  (let ((sql (format
              nil
              "select id from answers where myid='~a' and num='~a'"
              (myid)
              num)))
    (not (null (dbi:fetch (query sql))))))


;; BUG? 古いデータではなく新しい方を old_answers に入れてないか？
;; CHANGED: backup to old_answers, 2018-11-10
(defun update (myid num answer)
  (let* ((old (format
               nil
               "select answer from answers where myid='~a' and num='~a'"
               myid
               num))
         (old-answer (unescape-apos (second (dbi:fetch (query old)))))
         (sql0 (format
                nil
                "insert into old_answers (myid, num, answer, timestamp)
          values ('~a', '~a', '~a', now())"
                myid
                num
                (escape-apos old-answer)))

         ;;
         (sql (format
               nil
               "update answers set answer='~a', timestamp=now()
          where myid='~a' and num='~a'"
               (escape-apos answer)
               myid
               num)))
    (query sql0)
    (query sql)
    (redirect "/others")))

;;CHANGED: create_at -> timestamp
(defun insert (myid num answer)
  (let ((sql (format
              nil
              "insert into answers (myid, num, answer, timestamp)
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
      (:ul
       (:li "回答の上にコメントで作った関数の説明を入れること。"
            "for と if を使った、なんつーのは説明にならない。")
       (:li "回答提出後 3 時間は訂正できない。")
       (:li "Submit できたら他の回答、コメントを読み、"
            "間違いや勉強になった点があったらコメントつけよう。"))

      (:form :method "post" :action "/submit"
             (:input :type "hidden" :name "num" :value num)
             (:textarea :name "answer" :cols 60 :rows 10
                        :placeholder "プログラムの動作を確認後、
          correct indentation して、送信するのがルール。
          ケータイで回答もらって平常点インチキしても
          中間テスト・期末テストで確実に負けるから。
          マジ勉した方がいい。")
             (:br)
             (:input :type "submit" :class "btn btn-sm btn-primary")))))

(defun solved (myid)
  (let* ((q (format
             nil
             "select num from answers where myid='~a'"
             myid))
         (ret (dbi:fetch-all (query q))))
    (mapcar (lambda (x) (getf x :|num|)) ret)))

(defun my-password (myid)
  (let* ((q (format
             nil
             "select password from users where myid='~a'"
             myid))
         (ret (dbi:fetch (query q))))
    (getf ret :|password|)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;1.23.3, 1.23.9
;;now() が思った通りの値を返さないか？
;;bugfix: localtimestamp だ。
;;
;; sin-bin 3hours. 2020-11-09
(define-easy-handler (update-answer :uri "/update-answer") (num answer)
  (let* ((now (getf (dbi:fetch (query "select localtimestamp"))
                    :|localtimestamp|))
         (q (format nil "select timestamp + interval '3 hour' from answers
                          where myid='~a' and num='~a'" (myid) num))
         (sin-bin (second (dbi:fetch (query q)))))
    (if (< sin-bin now)
        (if (check answer)
            (update (myid) num answer)
            (page
              (:h3 "error"
                   (:p "ビルドに失敗。アップデートでバグが入ったか？"))))
        (page
          (:h2 (format t "Sin-Bin: ~a seconds" (- sin-bin now)))
          (:p "一定時間以内のアップデートは禁止です。")))))

(defun todays-answer (id)
  (let* ((q (format
             nil
             "select count(*) from answers where myid='~a' and
              timestamp > current_date" id))
         (ret (dbi:fetch (query q))))
    (getf ret :|count|)))

(defparameter *max-a-day* 10)

(define-easy-handler (submit :uri "/submit") (num answer)
  (cond
   ((not (myid)) (redirect "/login"))
   ((< *max-a-day* (todays-answer (myid)))
    (page
     (:h1 "明日にしよう")
     (:p "期末テスト前の荒れた投稿と3月以降のみんなの状況から"
         "一日に投稿できる回答数を制限している。")
     (:p "コピー回答を自分の回答として何通出しても勉強にならんやろ。")
     (:p "もうすぐ追試だ。できるようになってないと不合格は当たり前。"
         "暗記するんじゃなく、できるようになって来なさい。")))
   ((not (check answer))
    (page
     (:h3 "error")
     (:p "問題を解くアイデア、アプローチをコメントで書くこと。"
         "「for と if でリターンした」なんつーのサイテー。")
     (:p "ブラウザのバックで戻り、"
         "関数定義の上に説明コメントを書き足して"
         "再提出してください。")
     (:p "p1, p11, p22, p41 の hkimura(2999) の回答を参考に。")))
   (t
    (let* ((_ (insert (myid) num answer))
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
       (:p "さらに R99 続ける前に他の受講生の回答に"
           (:a :href (format nil "/answer?num=~a" num) "コメント")
           "しよう。")
       (:p "間違いあったら hkimura が見つける前に指摘する。"
           "「いい」と思ったら自分がもらって嬉しいと思うコメントを。"))))))

(define-easy-handler (answer :uri "/answer") (num)
  (if (myid)
      (if (answered? num)
          (show-answers num)
          (submit-answer num))
      (redirect "/login")))

(define-easy-handler (download :uri "/download") ()
  (if (myid)
      (let ((ret
              (dbi:fetch-all
               (query
                (format
                 nil
                 "select num, answer from answers where myid='~a' order by num"
                 (myid))))))
        (page
          (:pre :class "download" "#include &lt;stdio.h>
#include &lt;stdlib.h>")
          (loop for row in ret
                do
                   (htm
                    (:pre "//" (str (getf row :|num|)))
                    (:pre (str (escape (getf row :|answer|))))))
          (:pre "int main(void) {
    // 定義した関数の呼び出しをここに。
    return 0;
}")))
      (redirect "/login")))
;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; changed: 2020-10-24
;; 全員を回答数で並べて、自分が上から何番目のグループ化を数える。
;; 重いなあ。
(defun ranking (id)
  (let* ((uid (parse-integer id))
         (q "select distinct myid, count(myid) from answers
               group by myid order by count(myid) desc")
         (ret (query q))
         (n 1))
    (loop for row = (dbi:fetch ret)
          while (and row (not (= uid (getf row :|myid|))))
          do
             (incf n))
    n))
;;;
;;; status
;;;
(defun cheerup (sc)
  (cond
    ((< 110 sc)
     (list "kame-sennin.jpg" ""))
    ((< 99 sc)
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

(defun get-last ()
  (getf
   (dbi:fetch
    (query "select count(distinct myid) from answers"))
   :|count|))

(defun num-max ()
  (getf
   (dbi:fetch (query "select max(num) from problems"))
   :|max|))

(defun last-runner ()
  (getf
   (dbi:fetch
    (query "select count(distinct myid) from answers"))
   :|count|))

(defun get-jname ()
  (let* ((myid (myid))
         (q (format nil "select jname from users where myid='~a'" myid))
         (ret (dbi:fetch (query q))))
    (getf ret :|jname|)))

;; CHECK: work?
(defun answers-with-comment (id)
  (mapcar
   (lambda (x) (getf x :|num|))
   (dbi:fetch-all
    (query
     (format
      nil
      "select num from answers where myid='~a' and
answer like '%/* comment from%' order by num"
      id)))))


(define-easy-handler (status :uri "/status") ()
  (if (myid)
      (let* ((num-max (get-num-max))
             (sv (apply #'vector (solved (myid))))
             (sc (length sv))
             (cheer (cheerup sc))
             (image (first cheer))
             (message (second cheer))
             (jname (get-jname))
             (last-runner (get-last)))
        (page
          (:h3 "回答状況")
          (:p "クリックして問題・回答にジャンプ。")
          (loop for n from 1 to num-max
                do
                   (htm (:a :href (format nil "/answer?num=~a" n)
                            :class (if (find n sv) "found" "not-found")
                            (str n))))
          (:p "コメントがついた回答があります --> "
              (str (answers-with-comment (myid))))
          ;; (mapcar
          ;;  (lambda (x) (htm (:p x)))
          ;;  (answers-with-comment (myid)))
          (htm (:p (:img :src image) (str message)))
          (:hr)
          (:h3 "アクティビティ")
          (:p "毎日ちょっとずつが実力のもと。一度にたくさんは身にならんやろ。")
          (:p (:a :href "/activity" "&rArr; activity"))
          (:hr)
          (:h3 "ランキング")
          (:ul
           (:li "氏名: " (str jname))
           (:li "回答数: " (str sc))
           (:li "ランキング: " (str (ranking (myid))) "位 / 275 人"
                " (最終ランナーは " (str last-runner) "位と表示されます
  (無回答者を除く))"))
          (:hr)
          (:h3 "自分回答をダウンロード")
          (:p "全回答を問題番号順にコメントも一緒にダウンロードします。")
          (:p (:a :href "/download" "&rArr; download"))
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
;; menu, activity
;;

(define-easy-handler (activity :uri "/activity") ()
  (let ((res
          (dbi:fetch-all
           (query
            (format
             nil
             "select date(timestamp), count(date(timestamp))
 from answers where myid='~a'
 group by date(timestamp)
 order by date(timestamp) desc" (myid))))))
    (page
      (:h2 (str (myid)) " Activity")
      (:hr)
      (loop for row in res
            do (format t "<p>~a ~a</p>"
                       (yyyy-mm-dd  (getf row :|date|))
                       (stars (getf row :|count|))))
      (:p (:a :href "/status" "status") "に戻る"))))

(setf (html-mode) :html5)

;; dry!
(defun publish-static-content ()
  (let ((entities
          '("grading.html"
            "results-high.png"
            "results-low.png"
            "2__9.png"
            "a-gift-of-the-sea.jpg"
            "cat2.png"
            "dog.png"
            "favicon.ico"
            "fight.png"
            "fuji.png"
            "goku.png"
            "guernica.jpg"
            "hakone.jpg"
            "happier.png"
            "happiest.png"
            "happy.png"
            "integers.txt"
            "kame.png"
            "kame-sennin.jpg"
            "kutsugen.jpg"
            "ng.png"
            "ng-2--3.png"
            "panda.png"
            "r99.css"
            "readme.html"
            "robots.txt"
            "sakura.png"
            "sorry-2900.png"
            "by-numbers.svg"
            "by-answers.svg")))
    (loop for i in entities
          do
             (push (create-static-file-dispatcher-and-handler
                    (format nil "/~a" i)
                    (format nil "static/~a" i))
                   *dispatch-table*))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; status, login/logout, signin
;;;
(defun hkim-p ()
  (page
    (:h2 "are you hkimura?")
    (:p
     (:a :href "/logout" "no")
     " | "
     (:a :href "/problems" "yes"))))

(define-easy-handler (auth :uri "/auth") (id pass)
  (if (or (myid)
          (and (not (null id))
               (not (null pass))
               (string= (password  id) pass)
               (set-cookie *myid* :value id :max-age 86400)
               ))
      (if (string= id "2999")
          (hkim-p)
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
           (:p (:input :type "submit" :value "login"))
           (:ul (:li "myid の保存にクッキーを利用しています。
          ログインできない時はクッキー有効にして再挑戦してください。")))))

(define-easy-handler (logout :uri "/logout") ()
  (set-cookie *myid* :max-age 0)
  (redirect "/login"))

(define-easy-handler (passwd :uri "/passwd") (myid old new1 new2)
  (let ((stat "パスワードを変更しました。"))
    (page
     (:h2 "change password")
     (if (string= (my-password myid) old)
         (if (string= new1 new2)
             (query (format
                     nil
                     "update users set password='~a', timestamp='now()'
                       where myid='~a'"
                     new1
                     myid))
             (setf stat "パスワードが一致しません。"))
         (setf stat "現在のパスワードが一致しません"))
     (:p (str stat)))))


(defun get-new-myid ()
  (let* ((q (format nil "select myid from users where sid is null"))
         (ret (dbi:fetch (query q))))
    (getf ret :|myid|)))

(define-easy-handler (do-signin :uri "/do_signin") (sid jname pass1 pass2)
  (if (and (= 8 (length sid))
           (string= pass1 pass2)
           (< 0 (length jname)))
    (let* ((sid (string-upcase sid))
           (myid (get-new-myid))
           (q (format
               nil
               "update users
                 set sid='~a', password='~a', jname='~a', timestamp='now()'
                 where myid='~a'"
               sid pass1 jname myid)))
      (query q)
      (page
        (:p (format t "学生番号: ~a " sid))
        (:p (format t "氏名: ~a" jname))
        (:p (format t "myid: ~a" myid))
        (:p (format t "パスワード: ~a" pass1))
        (:p (format t "myid, パスワードをメモしたら、
                       <a href='/login'>login</a> からログインしよう。"))))
   (page
     (:p "学生番号が不正か、パスワードが一致しません。氏名を正しくタイプしましたか？")
     (:p "もう一度 <a href='/signin'>signin</a> からやり直してね。"))))

(define-easy-handler (signin :uri "/signin") ()
  (page
   (:h2 "SIGNIN")
   (:p "成績用の学生番号と R99 の myid を対応させます。")
   (:p "サインインに成功すると myid を一度だけ表示するので、"
       "パスワードと共に覚えること。")
   (:form :method "post" :action "/do_signin"
          (:p "学生番号")
          (:p (:input :type "text" :name "sid"))
          (:p "氏名")
          (:p (:input :type "text" :name "jname"))
          (:p "パスワード（同じのを2回）")
          (:p (:input :type "password" :name "pass1"))
          (:p (:input :type "password" :name "pass2"))
          (:p (:input :type "submit" :value "signin")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun start-r99 (&optional (port *http-port*))
  (format t "R99_HOST: ~a~%" (getenv "R99_HOST"))
  (format t "R99_DB: ~a~%"   (getenv "R99_DB"))
  (if (localtime)
      (format t "database connection OK.~%")
      (error "check your datanase connection.~%"))
  ;;(read-midterm "midterm.txt")
  (publish-static-content)
  (setf *server* (make-instance 'easy-acceptor
                                :address "0.0.0.0"
                                :port port
                                :document-root #p "."))
  (start *server*)
  (format t "r99-~a started at ~d.~%" *version* port))

(defun stop-r99 ()
  (stop *server*))

(defun main ()
  (start-r99)
  (loop (sleep 60)))
