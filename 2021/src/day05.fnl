(local utils (dofile "src/utils.lua"))

(fn add_vent [tbl x y]
  (when (not (. tbl x))
    (tset tbl x {}))
  (tset tbl x y (+ 1 (or (. tbl x y) 0))))

(fn sum_vents [field]
  (var sum 0)
  (each [_ colum (pairs field)]
        (each [_ cell (pairs colum)]
              (when (> cell 1)
                (set sum (+ sum 1)))))
  sum)

(var field {})
(each [line (io.lines "inputs/day05.txt")]
      (let [(x1 y1 x2 y2) (utils.parse_numbers_values line)]
        (if (= x1 x2)
          (for [y (math.min y1 y2) (math.max y1 y2)]
            (add_vent field x1 y))

          (= y1 y2)
          (for [x (math.min x1 x2) (math.max x1 x2)]
            (add_vent field x y1)))))

(print (sum_vents field))

(var field {})
(each [line (io.lines "inputs/day05.txt")]
      (let [(x1 y1 x2 y2) (utils.parse_numbers_values line)]
        (if (= x1 x2)
          (for [y (math.min y1 y2) (math.max y1 y2)]
            (add_vent field x1 y))

          (= y1 y2)
          (for [x (math.min x1 x2) (math.max x1 x2)]
            (add_vent field x y1))

          (let [dx (if (< x1 x2) 1 -1)
                dy (if (< y1 y2) 1 -1)]
            (var x x1)
            (var y y1)
            (for [_ 0 (math.abs (- x1 x2))]
              (add_vent field x y)
              (set x (+ x dx))
              (set y (+ y dy)))))))

(print (sum_vents field))
