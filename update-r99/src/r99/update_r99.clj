(ns r99.update-r99
  (:require [clojure.java.jdbc :as jdbc]
            [clojure.string :as string]
            [clojure.edn :as edn]
            [seesaw.core :refer :all]))


(def pg {:dbtype   "postgresql"
         :user     "user1"
         :password "pass1"
         :host     "localhost"
         :dbname   "r99"})

(declare create)

(defn update-r99 [e n text]
  (jdbc/update! pg :problems {:detail text} ["num = ?" n])
  (dispose! (.getSource e))
  (when-let [n (edn/read-string (input "Next problem?"))]
    (create n)))

(defn create [n]
  (let [detail (:detail (first (jdbc/find-by-keys pg :problems {:num n})))
        text (text
              :text detail
              :multi-line? true
              :wrap-lines? true)
        btn  (button
              :text "update"
              :listen [:action #(update-r99 % n (value text))])
        f    (frame
              :title (str "r99 " num)
              :on-close :exit
              :width 400
              :height 200
              :content (vertical-panel
                        :items [(scrollable text) btn]))]
    (-> f show!)))

(defn -main [num & args]
  (create (Integer. num)))
