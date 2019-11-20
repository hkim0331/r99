(ns seed-users
  (:require [clojure.string :refer [split]]
            [clojure.java.jdbc :as j]))

(def uid-myid
  (map (fn [a] {:uid (first a) :myid (Integer/parseInt (second a))})
       (map (fn [s] (split s #" "))
            (split (slurp "data/icome9.txt") #"\n"))))

(defn third [x]
  (first (next (next x))))

(def sid-jname
  (map (fn [a] {:jname (second a) :sid (third a)})
       (map (fn [s]  (split s #","))
            (remove (fn [s] (re-find #"^#" s))
                    (split (slurp "data/students.txt") #"\n")))))

(defn uid->sid [u]
  (let [body (apply str (take 4 (drop 3 u)))]
    (cond
      (re-find #"^s1a" u) (str "181A" body)
      (re-find #"^r10" u) (str "1710" body)
      (re-find #"^p10" u) (str "1510" body)
      :else :dunno)))

(def sid-uid-myid
  (map (fn [e] (assoc e :sid (uid->sid (:uid e)))) uid-myid))

(defn jname [sid]
  (:jname
   (first
    (filter #(= sid (:sid %)) sid-jname))))

(def sid-uid-myid-jname
  (filter #(:jname %)
          (map (fn [e] (assoc e :jname (jname (:sid e)))) sid-uid-myid)))

(def pg {:dbtype "postgresql"
         :dbname "r99"
         :host "localhost"
         :user "user1"
         :password "pass1"})

(def sid-myid-jname
  (map #(dissoc % :uid) sid-uid-myid-jname))

(j/insert-multi! pg :users sid-myid-jname)

