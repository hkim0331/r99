#!/usr/bin/env bb
;; can not.
;;(require '[environ.core :refer [env]])

(require '[babashka.pods :as pods])

(pods/load-pod "pod-babashka-postgresql")

(require '[pod.babashka.postgresql :as pg])

(def db {:dbtype   "postgresql"
         :host     ""
         :port     5432
         :dbname   ""
         :user     ""
         :password ""})

(defn prn-query [q] (prn (pg/execute! db q)))

(prn-query ["select count(*) from answers"])

;; FIXME: without ::text, GMT,
;;        with ::text, JST, but still iso format.k
(prn-query ["select num, myid, timestamp::text from answers where id=(select max(id) from answers)"])


