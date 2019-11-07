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

(j/delete! pg :users ["sid = ?" "hkimura"])
(j/delete! pg :users ["sid = ?" "nakadou"])