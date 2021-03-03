# R99

## Unreleased
* src/plot-by-{answers,numnbers} をひとつにまとめる。
* cd src && make plot を定時実行する。
* plot をアップデートした日時を表示する。
* copy コマンド
  copy src dest
  copy src

## Released
### [2.39.4] - 2021-03-03
* tag がm2とm3で一致して運用できてないので、新しいのをつけてみる。

### [2.39.2] - 2021-03-02
* fill 80 columns.

### [2.39.0] - 2021-03-02
* count working days.
* FIXME: slow. need improvements.

### [2.38.0] - 2021-03-02
* added static/grading.html.

### [2.37.0] - 2021-02-26
* リセット。

### [2.35.0] - 2021-02-10
* 期末試験終了、受講生の希望により、r99 動かしておく。

### [2.34.7] - 2021-02-07
* ギブアップ宣言

    心ない受講生によって R99 はもう役目を果たしてない。
    ダメ出しコメント出すべきだろうが、評価できない投稿多すぎ。真面目な前向き受講生が沈んでいる。ごめんね。

### [2.33.15] - 2021-01-31
* app.melt/r101.html へのリンク。

### [2.33.12] - 2021-01-28
* 亀仙人。

### [2.33.11] - 2021-01-27
* svg グラフに戻し。

### [2.33.10] - 2021-01-27
* svg グラフに代わって 144-warn-r99.html

### 2021-01-18
* update-r99/src/update_r99.clj を update-r99/src/r99/update_r99.clj に移動。

### [2.33.7] - 2021-01-12
* answer は // に続き、';', ')' を含むテキストでなければならない。

### [2.33.4] - 2020-12-31
* ADDED: by-numbers と同じく、by-answers プロット。

### [2.33.3] - 2020-12-31
* CHANGED: submit したらコメントを促すメッセージ。
* ADDED: make reinstall で svg をアップデートする。

### [2.33.1] - 2020-12-31
* REMOVED: app.melt で r99/static を git add/commit してしまった間違いを
  取り消す。static は r99/src/static にあるべき。

### [2.33.0] - 2020-12-31
* ADDED: plot-by-numbers 設問ごとの回答数を svg グラフにセーブ。
  /problems ページの上部に表示する。

### [2.32.3] - 2020-12-09
* bugfix: sql にスペースが入り込んでしまった。

### [2.32.2]
* bug: env.sh を読めなくて、取り消した、はず。

### [2.32.1] - 2020-12-06
* bugfix "env.sh" がある時だけ、読む。

### [2.32.0] - 2020-12-05
* -w -fsyntax-only

### [2.31.0] - 2020-11-29
* read-env

### [2.30.6] - 2020-11-29
* 中間テスト採点発表

### [2.30.0] - 2020-11-21
* 回答にはコメント必要とする。

### [2.29.5] - 2020-11-10
* fix typo, add advices to students.

### [2.29.4] - 2020-11-09
* FIXED 2.29.0-2.29.3 の間でエンバグ。

### [2.29.0] - 2020-11-09
* /old-version
* sin-bin を 3hours に。

### [2.28.5] - 2020-11-06
* C# か。あれか、原因は。

### [2.28.4] - 2020-11-04
* update /others, readme.html

### [2.28.2] - 2020-11-03
* /recent 追加。/recent で最近の10、/recent?n=3 で最近の3の
  timestamp, myid, num を表示する。

### [2.28.1] - 2020-11-02
* fix typo.

### [2.28.0] - 2020-11-02
* データベース接続時のユーザ名、パスワードを関数から定数に。
  体感速度変わるはず。
* データベース接続エラーは即座に終了。
  これまでは最初の接続に行ってエラーになるまで生かしてた。
* /admin の代わりに readme メニュー。

### [2.27.0] - 2020-11-02
* midterm.txt が見つからなくてもエラーにしない。

### [2.26.9] - 2020-11-02
* コメントにもタイムスタンプを表示する。文字列としてコメントにアペンド。

### [2.26.7] - 2020-10-25
* app.melt: 毎朝 9:30 にデータベース r99 をバックアップ。
* /others: 受講者数 273 に修正(was 260)

### [2.26.6] - 2020-10-24
/status を再チェック。
* hkimura の名前が表示されない NULL なのはデータベースに名前が入ってないだけ。
* ランキングは重い SQL になっている。Redis の出番である感じ。

### [2.26.4] - 2020-10-07
* sid の長さチェックと大文字にしてデータベースへセーブ。

### [2.26.3] - 2020-10-06
* emacs での編集中に if のかっこがずれた。

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
