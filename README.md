# R99

## 2019-11-04

[1.5.1] under construction for 2019

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
