# R99

## Unreleased
* midterm.txt をデータベースに入れないとアップデートがめんどくさい。
* problems を 99 題にまとめる。




### [2.26.1] - 2020-10-05
* multipass の 18.04 では動作するのに、
  app.melt で Internal Server Error になるのはなぜ？
  ソースごと持って行ってみるか。
  => 開発機のフォルダ構成を反映するのかな？
  そんなん、ひどいな。そうできない本番機だってありそう。


### [2.26.0] - 2020-10-05
* サインイン用の /signin を作成。
* /others のエラーをフィックス。
* /admin のエラーをフィックス。


### [2.25.0] - 2020-10-04
* 2020 開発スタート。
* macOS の postgres がバージョン12、
  ubuntu 18.04 はバージョン10 なので、
  multipass で 18.04 を動かす。
  macOS へ ssh ポートフォワードする。


---

## [1.24.2] - 2020-02-06
ばかなやつがいるもんだ。

## [1.24.0] - 2020-02-06
### fix
* 自分のダウンロードはコピーできる。
* コメントのコードはコピーできない。

## [1.23.9] 2020-01-30
### bugfix
now() だと timezone が余計。
localtimestamp だと timezone がつかない。
https://www.postgresql.jp/document/9.3/html/functions-datetime.html

### add
* アップデート制限時間(Sin-Bin)を表示

## [1.22.5] 2020-01-21
### change
* db/update-r99 を 上位フォルダに移す。
* 複数の問題修正を連続してできるように。declare を覚えた。あと、input、Integer.
  (require '[clojure.edn :as edn]) しておいて、(edn/read-string "32") も覚えよう。

## [1.19] 2019-12-18

環境変数を実行時に読み込む。db-host, db-user, db-pass 関数。を追加。
host, user, pass のいずれかはシステム関数と名前がバッティング、r99 システムを
動作不能にしてしまうので注意。

## [1.18] 2019-11-27

admin ページ（old answers 一覧を表示する）からコメントのページへのリンク。

## [1.17] 2019-11-27

tag つけ間違って飛んだ。
clojure seesaw で db/update 作成。

## [1.6.2] 2019-11-19

追加の16人分。db/data/after-9500.txt を用意して、db/after-9500.clj から流し込む。
初期パスワード忘れた。追加しとこ。

## [1.5.4] 2019-11-07

```
r99$ cd r99
r99$ git pull
r99$ make
```

## [1.5.1] 2019-11-04

* sid は整数ではなくなった。
* 問題を改良すること。文字列をポインタに。

## 2019-08-26, restart for robocar-2019

* postgres 11(macos), r99.melt は postgres 10.

## 2019-01-16

* ローカルな postgres と接続できること。
* postgres はポートフォワードが便利。
  $ ssh -fN -L 5432:localhost:5432 ubuntu@db.melt.kyutech.ac.jp
* src に降りて、ros emacs -nw する。

1. cd ${r99}
1. ros emacs -nw
1. M-x sly
1. (ql:quickload :r99)
1. (in-package :r99)
1. (start-server)


## 2018

### FIXME: 2019-02-11

slime や lisp-repl が
中間テストの結果を記録した midterm.txt のセーブ場所からスタートしないと
クラッシュする。

### 2018-12-08

* 記録されたデータをJSTに変換する
* 設定以降、記録するデータを JST にする

https://qiita.com/zkangaroo/items/93be2d4504c3d1d5f185

```sql
ALTER DATABASE r99 SET timezone TO 'Asia/Tokyo';
SELECT pg_reload_conf();
```

### 2018-11-12

* r99/src に降りて M-x-slime すれば working directory 問題は出ないか？
* `~/quicklisp` は r99 バイナリを作るときだけに必要？
  なのであれば、開発機にはいらないな。
* 1.1 を目指す。

### 2018-11-11

* 問題をポリッシュアップする。
* make seed 時に回答もひとつ、二ついれておくように。

### [1.0.1] 2018-11-10

* シンプルな SQL --- 回答カウントしていない。なんとかしないと。
* create_at/update_at を正しく使う
* [DONE] defvar hkimura
* [DONE] update の際にコピーを old_answers にとる。
* 一番の問題は問題。
* [BUG] answers がひとつもない時、エラー。
* answers は内容を表していない。
* [DONE] コメントはどうつけるんだっけ？
* [DONE] status にコメントのついた回答を表示のはずか？
* status/ranking が表示されない。

### [1.0]

新しく 2018 用のを準備始めたというだけで、完成度が 1.0 な訳ではない。

### FIXME

* インチキ防止

    update 時にコピー取る、で。
    別にテーブル用意して、アップデートの際はそっちにコピーしてから
    アップデートしよう。

```sql
create table old_answers (
       id serial primary key,
       myid       integer not null,
       pid        integer not null,
       answer     text,
       create_at  timestamp);
```

* make drop  create init でエラー
* gem update

---

# 2017

robocar-2017 用、簡単 C の 99 題。

## FIXME

* 2018-03-26 コンパイルするときの環境変数を見るのか？

```sh
$ export R99_HOST=db.melt.kyutech.ac.jp
$ make reinstall
```

だとエラーが出ない。

## Installation

```sh
$ git clone git@github.com:hkim0331/r99.git
```

Postgres との接続のため、次の環境変数をセット。

* R99_HOST
* R99_USER
* R99_PASS

db フォルダにてデータベースの作成とシード。

```sh
$ cd db
$ make create
$ make migrate
```

src フォルダに移り、環境変数を確認して、

```sh
$ cd ../src
$ make install
```

アップデートには make reinstall で。

## inner join の仕方メモ

```sql
r99=# select users.myid, users.sid, count(answer) from users
inner join answers
on users.myid=answers.myid
group by users.myid, users.sid;

 myid |   sid    | count
------+----------+-------
 7910 | 16104002 |     3
 8000 | 99999999 |     8

```

上の users.sid を users.midterm に変更し、answers に中間試験の成績を表示する。

## Usage

3030/tcp で hunchentoot が立ち上がる。
nginx のリバースプロキシ等でつないでやる。

## BUG

* db/insert-problem.rb しても、回答をつけない問題は /problems に表示さ
  れない。まっとうでもあるが。2018-01-28

* nginx.melt の postgres インタフェースが古いか？

```sh
hkim@nginx:~/r99/db$ ./fix-brackets.rb
The PGconn, PGresult, and PGError constants are deprecated, and will be
removed as of version 1.0.

You should use PG::Connection, PG::Result, and PG::Error instead, respectively.

Called from
/var/lib/gems/2.3.0/gems/sequel-4.45.0/lib/sequel/adapters/postgres.rb:9:in
`<top (required)>'
```

## author

hiroshi . kimura . 0331 @ gmail . com

## license

free.

---
hiroshi . kimura . 0331 @ gmail . com
