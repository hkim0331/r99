(ns problems
  (:require [clojure.string :as str]))

(count
 (remove #(str/starts-with? % ";")
         (str/split (slurp "problems.txt") #"\n\n")))
