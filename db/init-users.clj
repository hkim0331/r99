;;;; init-users
;;;; 300人分の myid を用意。
;;;; sid, jname, password はカラとする。

(ns init-users
  (:require
   [clojure.java.jdbc :as jdbc]
   [environ.core   :refer [env]]))

(def pg {:host     "localhost"
         :dbtype   "postgresql"
         :dbname   (env :r99-db)
         :user     (env :r99-user)
         :password (env :r99-pass)})

(def myids
   (map (fn [x] {:myid x})
        (take 300 (shuffle (range 2000 2900)))))

(jdbc/insert-multi! pg :users myids)

(jdbc/insert! pg :users
  {:myid 2998 :sid "nakadou" :password "r99"})
(jdbc/insert! pg :users
  {:myid 2999 :sid "hkimura" :password "r99"})
