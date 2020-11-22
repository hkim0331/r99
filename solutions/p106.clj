(* 2520 11 13 17 19 2)

(defn gcd [x y]
  (if (zero? y)
    x
    (gcd y (mod x y))))


(gcd 40 30)

(defn lcm [x y]
  (/ (* x y) (gcd x y)))


(lcm 30 40)
