(defn squares [n]
  (take-while #(< % n)
    (map #(* % %)
      (iterate inc 1))))

(defn cubics [n]
  (take-while #(< % n)
    (map #(* % % %)
      (iterate inc 1))))

(cubics 1000)

(defn s-and-c [n]
  (clojure.set/intersection
    (set (squares n))
    (set (cubics n))))

(apply max (s-and-c 1000001))

(squares 1000000)
(cubics  1000000)
(Math/sqrt 531441)
