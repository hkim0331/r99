# R99

robocar-2017 用、簡単 C の 99 題。

## Installation

```sh
$ git clone git@github.com:hkim0331/r99.git
```

Postgres との接続のため、次の環境変数をセット。

* R99_HOST
* R99_USER
* R99_PASS

db フォルダにてデータベースの作成とシード。

```
$ cd db
$ make create
$ make migrate
```

src フォルダに移り、環境変数を確認して、

```
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

## author

hiroshi . kimura . 0331 @ gmail . com

## license

free.

