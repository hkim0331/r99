* rsync-app-backups.sh - 2020-10-09
	db/backups を app.melt と同期する。

* 2020-10-05
  make

* problems のアップデート、clojure はファイルよりもネームスペース優先で。

		clj -m update-r99 38

* [FIXME] テーブルは user1/pass1 で作っておくとアクセス権が設定しやすい。
  そうしない場合、grant をテーブルの数x2 だけ、発行する必要がある。
  スクリプト作っておけばいいか。

* data/icome9.txt and data/students.txt are copied from
  ${r99}/sid-uid-myid-jname/

* data/problems.md is better than data/problems.txt?


