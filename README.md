# R99

robocar-2017 用、簡単 C の 99 題

## memo

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

## Installation

1. git clone し、
2.

```sh
$ git clone git@github.com:hkim0331/r99.git
```
$ . production.env
$ cd src
$ make reinstall
```

