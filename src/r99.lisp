(defpackage r99
  (:use :cl :cl-dbi :cl-who :cl-ppcre :cl-fad :hunchentoot))
(in-package :r99)

(defvar *version* "2.26.1")

(defvar *nakadouzono* 2998)
(defvar *hkimura*     2999)

;; midterm.txt ファイルがないと立ち上がらないか？
(defun read-midterm (fname)
  (with-open-file (in fname)
    (let ((ret nil))
      (loop for line = (read-line in nil)
         while line do
           (destructuring-bind (f s) (ppcre:split " " line)
             (push (cons (parse-integer f) (parse-integer s)) ret)))
      ret)))
(defparameter *mt* (read-midterm "midterm.txt"))

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

;; 2019-12-18, 関数に変更。
(defun db-host ()
  (or (getenv "R99_HOST") "localhost"))
(defun db-user ()
  (or (getenv "R99_USER") "user1"))
(defun db-pass ()
  (or (getenv "R99_PASS") "pass1"))

(defvar *db* "r99")
(defvar *server* nil)
(defvar *http-port* 3030)
(defvar *myid* "r99");; cookie name

(defun query (sql)
  (dbi:with-connection
   (conn :postgres
         :host (db-host)
         :username (db-user)
         :password (db-pass)
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

;; to jst
;; (defun jst (utc)
;;   )

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
     (:a :href "/problems" "problems")
     " | "
     (:a :href "/others" "others")
     " | "
     (:a :href "/status" "status")
     " | "
     (:a :href "/login" "login")
     " / "
     (:a :href "/logout" "logout")
     " , "
     (:a :href "/signin" "signin")
     "|"
     (:a :href "/admin" "admin"))))

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
        :integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
        :crossorigin="anonymous")
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
  (if (zerop n) ret
    (stars-aux (- n 1) (concatenate 'string ret "*"))))

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

;;
;; admin
;;

(define-easy-handler (show-old :uri "/show-old") (id)
  (let* ((q (format
             nil
             "select myid,num,answer,timestamp::text from old_answers where id='~a'"
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
        (let* ((ret (query "select id, timestamp::text, myid, num,
  answer from old_answers order by id desc")))
          (page
           (:p "db-host: " (str (db-host)))
           (loop for row = (dbi:fetch ret)
              while row
              do
                (format
                 t
                 "<p><a href='/show-old?id=~a'>~a</a> [~a] ~a ~a</p>"
                 (getf row :|id|)
                 (subseq (getf row :|timestamp|) 0 19)
                 (getf row :|myid|)
                 (getf row :|num|)
                 ;; fix. 2018-12-08.
                 (my-subseq 60 (getf row :|answer|))
                 ))))
        (redirect "/login"))))
;;
;; answers
;;

(define-easy-handler (users-alias :uri "/answers") ()
  (redirect "/others"))

;; FIXED: UTC => JST
;; 2018-12-08 以降、記録が JST になる。
;; どうやったんだっけ？
;; () は中間試験成績を出していた。

(define-easy-handler (users :uri "/others") ()
  (page
   ;;    (:p (:img :src "/guernica.jpg" :width "100%"))
   (:p (:img :src "/kutsugen.jpg" :width "100%"))
   (:p :align "right" "「屈原」横山大観(1868-1958), 1898.")
   (:h2 "誰が何問?")
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

     ;; BUG: 回答が一つもないとエラーになる、かな。
     (htm
      (:li
       (format
        t
        " ~a、~a さんが
      <a href='/answer?num=~a'>~a</a> に回答しました。"
        (short (getf recent :|timestamp|))
        (getf recent :|myid|)
        (getf recent :|num|)
        (getf recent :|num|)))
      (:li
       (format
        t
        "<span class='yes'>赤</span> は過去 48 時間以内にアップデート
      があった受講生です。全回答数 ~a。"
        (count-answers)))
      (:li "( ) は中間テスト、個人ペーパーの点数。")
      (:hr))

     (loop for row = (dbi:fetch results)
        while row
        do
          (let* ((myid (getf row :|myid|))
                 (working (if (find myid working-users) "yes" "no")))
            (format
             t
             "<pre><span class=~a>~A</span> (~a) ~A<a href='/last?myid=~d'>~d</a></pre>"
             working
             myid
             (cdr (assoc myid *mt*))
             (stars (getf row :|count|))
             myid
             (getf row :|count|)))
          (incf n))

     (htm (:p "受講生 210 人、一題以上回答者 " (str n) " 人。")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; /problems
;;
;; (define-easy-handler (index-alias :uri "/") ()
;;   (page
;;     (:h1 :class "warn" "WARNING")
;;     (:p "回答にならない回答出して、他人の回答をコピー、"
;;         "自分の回答としてアップデートするの良くない。"
;;     (:p "下らんやつがいると面倒だよ。わからんと思ってるのか？期末テストはダメだね。"
;;         "何か対策します。")
;;     (:p (:a :href "/problems" "問題ページ"))))

(define-easy-handler (index-alias :uri "/") ()
  (redirect "/problems"))

(defun zero_or_num (num)
  (if (null num)
      0
      num))

;; CHANGED: (count) をどう表示するか？2017 は複雑な SQL 流してた。
;; answers テーブルから別に引くように。2018-11-14

(define-easy-handler (problems :uri "/problems") ()
  (let ((results
          (query "select num, detail from problems order by num"))
        (answers
          (query "select num, count(*) from answers group by num"))
        (nums (make-hash-table)))
    (loop for row = (dbi:fetch answers)
          while row
          do
             (setf (gethash (getf row :|num|) nums) (getf row :|count|)))
    (page
      (:h1 :style "color:red; font-size:24pt" "🔥UNDER CONSTRUCTION🔥")
      (:p "利用開始までもうちょっと。")
      ;;     (:p (:img :src "/a-gift-of-the-sea.jpg" :width "100%"))
      ;;     (:p :align "right" "「海の幸」青木 繁(1882-1911), 1904.")
      (:h2 "problems")
      (:ul
       (:li "番号をクリックして回答提出。ビルドできない回答は受け取らない。")
       (:li "上の方で定義した関数を利用する場合、上の関数定義は回答に含めないでOK。")
       (:li "すべての回答関数の上には #include <stdio.h> #include <stdlib.h> があると仮定してよい。（実際にある）")
       (:li :class "warn"
          "正真正銘自分作のプログラムでも、動作を確認してないプログラムはゴミです。"))

      ;;(:h1 :class "warn" "WARNING")
      ;;(:p :class "warn"
      ;;    "回答にならない答を一旦提出、他人の回答をコピーし、"
      ;;    "自分の回答としてアップデートするの、やめよう。"
      ;;    "発覚しないと思っていたら大間違い。")
      ;;(:p :class "warnwarn" "と授業で何度も言っても、"
      ;;    "ここに書いてもわからない奴がいるな。myid は 9037。"
      ;;    " <a href='https://r.hkim.jp/9037.html'>そいつの回答</a>、"
      ;;    "見てみよう、全部 hello, robocar だから。"
      ;;    "回答変更できないようパスワード変えた。しばらく晒しとく。単位はあるかな？"
      ;;    (:span :class "warn" "ないでしょ。"))

      (:hr)
      (loop for row = (dbi:fetch results)
            while row
            do
               (let ((num (getf row :|num|)))
                 (format t "<p><a href='/answer?num=~a'>~a</a>(~a) ~a</p>~%"
                         num
                         num
                         (zero_or_num (gethash num nums))
                         (getf row :|detail|)))))))

;;
;; add-comment
;; timestamp は変えない。
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
      (:pre :class "answer" (str (escape (getf ret :|answer|))))
      (:form :methopd "post" :action "/add-comment"
             (:input :type "hidden" :name "id" :value id)
             (:textarea :rows 5 :cols 50 :name "comment"
                        :placeholder "暖かいコメントをお願いします。")
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
          "select id, myid, answer, timestamp::text from answers
          where not (myid='~a') and not (myid='8000') and not (myid='8001')
          and num='~a'
          order by timestamp desc
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
                        :rows (+ 1 (count #\linefeed my-answer :test #'equal))
                        (str (unescape-apos my-answer)))
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
                (short (getf row :|timestamp|))
                (getf row :|id|)
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
                (escape-apos old-answer)
                ))
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

;;CHANGED: timestamp -> timestamp
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
      ;; (:ul :class "warn"
      ;;  (:li "自分の理解を深めようとしない点数稼ぎは教員の労力、"
      ;;       "採点の無駄時間が増えるだけ。<br>"
      ;;       "やめましょう。"
      ;;       "理解が深まらないままじゃ期末テストでも挽回できないよ。")
      ;;  (:li "ビルドできない回答は受け取らない。")
      ;;  (:li "回答を受け取ってもそれが正解とは限らない。")
      ;;  (:li "submit できたら、他の受講生の回答と自分の回答をよく見比べること。"))
      (:ul
       (:li :class "warn" "動作確認していない回答出すな。全部、回答は記録してある。")
       (:li :class "warn" "回答提出後24時間は訂正できないよう変更するので、慎重に回答すること。"))
      (:form :method "post" :action "/submit"
             (:input :type "hidden" :name "num" :value num)
             (:textarea :name "answer" :cols 60 :rows 10
                        :placeholder "プログラムの動作を確認後、
          correct indentation して、送信するのがルール。
          ケータイで回答もらって平常点インチキしても
          中間テスト・期末テストで確実に負けるから。
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; status, login/logout, signin
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
           (:p (:input :type "submit" :value "login"))
           (:ul (:li "myid の保存にクッキーを利用しています。
          ログインできない時はクッキー有効にして再挑戦してください。")))))

(define-easy-handler (logout :uri "/logout") ()
  (set-cookie *myid* :max-age 0)
  (redirect "/problems"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;1.23.3, 1.23.9
;;now() が思った通りの値を返さないか？
;;bugfix: localtimestamp だ。
(define-easy-handler (update-answer :uri "/update-answer") (num answer)
  (let* ((now (getf (dbi:fetch (query "select localtimestamp")) :|localtimestamp|))
         (q (format nil "select timestamp + interval '1 day' from answers where myid='~a' and num='~a'" (myid) num))
         (after-1-day (second (dbi:fetch (query q)))))
    (if (< after-1-day now)
        (if (check answer)
            (update (myid) num answer)
            (page
              (:h3 "error")
              (:p "ビルドできない。バグ混入？")))
        (page
          (:h2 (format t "Sin-Bin: ~a seconds" (- after-1-day now)))
          (:p "他人の回答をコピって出すのが目に付く。24時間以内のアップデートは禁止にしました。")
          (:p "バカな野郎が数人いるだけでみんなが迷惑。悪事はバレる。自覚しなさい。")))))

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
      (if (answered? num)
          (show-answers num)
          (submit-answer num))
      (redirect "/login")))

(define-easy-handler (passwd :uri "/passwd") (myid old new1 new2)
  (let ((stat "パスワードを変更しました。"))
    (page
      (:h2 "change password")
      (if (string= (my-password myid) old)
          (if (string= new1 new2)
              (query (format
                      nil
                      "update users set password='~a', timestamp='now()' where myid='~a'"
                      new1
                      myid))
              (setf stat "パスワードが一致しません。"))
          (setf stat "現在のパスワードが一致しません"))
      (:p (str stat)))))

(define-easy-handler (download :uri "/download") ()
  (if (myid)
      (let ((ret
              (query
               (format
                nil
                "select num, answer from answers where myid='~a' order by num"
                (myid)))))
        (page
          (:pre :class "download" "#include &lt;stdio.h>
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
;;;;


;;; 2020-10-05

(defun get-new-myid ()
  (let* ((q (format nil "select myid from users where sid is null"))
         (ret (dbi:fetch (query q))))
    (getf ret :|myid|)))

(define-easy-handler (do-signin :uri "/do_signin") (sid jname pass1 pass2)
  (if (string= pass1 pass2)
      (let* ((myid (get-new-myid))
             (q (format
                 nil
                 "update users set sid='~a', password='~a', jname='~a'
                    where myid='~a'"
                 sid pass1 jname myid))
             (ret (query q)))
        (page
          (:p (format t "学生番号: ~a " sid))
          (:p (format t "氏名 ~a" jname))
          (:p (format t "myid ~a" myid))
          (:p (format t "パスワード (表示しません)"))
          (:p (format t "<a href='/login'>login</a>からログインしよう。")))
        (page
          (:p "パスワードが一致しません。もう一度"
              "<a href='/signin'>signin</a>"
              "からやり直し。")))))

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
           (:p (:input :type "submit" :value "signin"))
           )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;; hotfix 1.3.1
;;; このままでいいや。
(defun ranking (id)
  (let ((uid (parse-integer id)))
    (if (<= uid 8500)
        -1
        (let* ((q "select distinct myid, count(myid) from answers
 group by myid order by count(myid) desc")
               (ret (query q))
               (n 1))
          (loop for row = (dbi:fetch ret)
                while (and row (not (= uid (getf row :|myid|))))
                do
                   (incf n))
          n))))
;;;
;;; status
;;;
(defun cheerup (sc)
  (cond
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
  (getf
   (dbi:fetch
    (query
     (format
      nil
      "select jname from users where myid='~a'"
      (parse-integer (myid)))))
   :|jname|))

;;CHECK: work?
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

(defun status-sub (sc)
  (cond
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
          (:li "ランキング: " (str (ranking (myid))) "位 / 246 人"
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
;; activity
;;
(define-easy-handler (activity :uri "/activity") ()
  (let ((res
         (query
          (format
           nil
           "select date(timestamp), count(date(timestamp))
 from answers where myid='~a'
 group by date(timestamp)
 order by date(timestamp) desc" (myid)))))
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

;; dry!
(defun publish-static-content ()
  (let ((entities
         '("robots.txt"
           "favicon.ico"
           "r99.css"
           "fuji.png"
           "panda.png"
           "kame.png"
           "dog.png"
           "cat2.png"
           "fight.png"
           "sakura.png"
           "hakone.jpg"
           "happy.png"
           "happier.png"
           "happiest.png"
           "goku.png"
           "guernica.jpg"
           "kutsugen.jpg"
           "a-gift-of-the-sea.jpg"
           "integers.txt")))
    (loop for i in entities
       do
         (push (create-static-file-dispatcher-and-handler
                (format nil "/~a" i)
                (format nil "static/~a" i))
               *dispatch-table*))))

(defun start-server (&optional (port *http-port*))
  (publish-static-content)
  (setf *server* (make-instance 'easy-acceptor
                              :address "0.0.0.0"
                              :port port
                              :document-root #p "."))
  (start *server*)
  (format t "r99-~a started at ~d.~%" *version* port))

(defun stop-server ()
  (stop *server*))

(defun main ()
  (start-server)
  (loop (sleep 60)))
