(ns update-r99
  (:use seesaw.core)
  (:require [clojure.string :refer [split]]
            [clojure.java.jdbc :as j]))

(def pg {:dbtype "postgresql"
         :dbname "r99"
         :host "localhost"
         :user "user1"
         :password "pass1"})

(defn update [n]
  (let [detail (first (j/find-by-keys pg :problems {:num n}))
        renew (input "r99" :value (:detail detail))]
    (if-not (empty? renew)
      (do
        (j/update! pg :problems {:detail renew} ["num = ?" n])
        (str "update as " renew)))))

(defn -main [num & args]
  (update num))
