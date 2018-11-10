# R99

## 2018

### [1.0.1] 2018-11-10

* シンプルな SQL --- 回答カウントしていない。なんとかしないと。
* create_at/update_at を正しく使う
* [DONE]defvar hkimura
* [DONE]update の際にコピーを old_answers にとる。
* 一番の問題は問題。
* [BUG] answers がひとつもない時、エラー。
* answers は内容を表していない。
* [DONE]コメントはどうつけるんだっけ？
* [DONE]status にコメントのついた回答を表示のはずか？
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
