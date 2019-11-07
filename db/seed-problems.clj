(ns seed-problems
  (:require [clojure.string :as str]
            [clojure.java.jdbc :as j]))

(def problems
  (remove #(str/starts-with? % "#")
          (str/split (slurp "data/problems.md") #"\n\n")))

(def with-number
  (map (fn [x]  {:num (first x) :detail (second x)})
       (zipmap (range 1 300) problems)))

(def pg {:dbtype "postgresql"
         :dbname "r99"
         :user "user1"
         :password "pass1"
         :host "localhost"})

(j/insert-multi! pg :problems with-number)
