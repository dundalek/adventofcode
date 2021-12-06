(local utils (dofile "src/utils.lua"))

(fn generation-naive [school]
  (each [i fish (ipairs school)]
        (if (= 0 fish)
          (do (tset school i 6)
              (table.insert school 9))
          (tset school i (- fish 1)))))

(fn increment-key [tbl k n]
  (tset tbl k
        (+ (or (. tbl k) 0) n)))

(fn generation-map [school]
  (let [new-school {}]
    (each [fish n (pairs school)]
          (if (= fish 0)
            (do (increment-key new-school 6 n)
                (increment-key new-school 8 n))
            (increment-key new-school (- fish 1) n)))
    new-school))

(fn sum-values [tbl]
  (var sum 0)
  (each [_ v (pairs tbl)]
        (set sum (+ sum v)))
  sum)

;; Part 1 - naive representation in a list
(var school (utils.read_nums_to_table "inputs/day06.txt"))
(for [j 1 80]
  (generation-naive school))
(print (length school))

;; Part 2 - represent state as a map
(var school {})
(each [_ n (ipairs (utils.read_nums_to_table "inputs/day06.txt"))]
      (increment-key school n 1))
(for [j 1 256]
  (set school (generation-map school)))
(print (sum-values school))
