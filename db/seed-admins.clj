(ns seed-admins
  (:require [clojure.string :refer [split]]
            [clojure.java.jdbc :as j]))

;;(defvar *nakadouzono* 8998)
;;(defvar *hkimura* 8999)

(def pg {:dbtype "postgresql"
         :dbname "r99"
         :host "localhost"
         :user "user1"
         :password "pass1"})

(j/insert! pg :users {:myid 8999 :sid "hkimura" :jname "hkimura"})
(j/insert! pg :users {:myid 8998 :sid "nakadou" :jname "中堂園"})

;; ついでにパスワードを
(j/update! pg :users {:password  "robocar"} ["password is null"])