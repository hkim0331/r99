(ns init-problems
  (:require [clojure.string    :as str]
            [clojure.java.jdbc :as jdbc]
            [environ.core      :as environ :refer [env]]))

(def problems
  (remove #(str/starts-with? % "#")
          (str/split (slurp "problems.md") #"\n\n+")))

(def with-number
 (let [now (str (java.util.Date.))]
  (map (fn [x] {:num (first x) :detail (second x)})
       (zipmap (range 1 300) problems))))

(def pg {:host     "localhost"
         :dbtype   "postgresql"
         :dbname   (env :r99-db)
         :user     (env :r99-user)
         :password (env :r99-pass)})

(jdbc/execute! pg ["delete from problems"])
(jdbc/insert-multi! pg :problems with-number)
