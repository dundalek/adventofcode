(local utils (dofile "src/utils.lua"))

(fn direction [c1 c2]
  (if (= c1 c2) 0
      (< c1 c2) 1
      -1))

(fn add-vent-point [field x y]
  (when (not (. field x))
    (tset field x {}))
  (tset field x y (+ 1 (or (. field x y) 0))))

(fn add-vent-line [field x1 y1 x2 y2]
  (let [dx (direction x1 x2)
        dy (direction y1 y2)
        steps (math.max (math.abs (- x1 x2))
                        (math.abs (- y1 y2)))]
    (var x x1)
    (var y y1)
    (for [_ 0 steps]
      (add-vent-point field x y)
      (set x (+ x dx))
      (set y (+ y dy)))))

(fn sum-vents [field]
  (var sum 0)
  (each [_ colum (pairs field)]
        (each [_ cell (pairs colum)]
              (when (> cell 1)
                (set sum (+ sum 1)))))
  sum)

(var field1 {})
(var field2 {})
(each [line (io.lines "inputs/day05.txt")]
      (let [(x1 y1 x2 y2) (utils.parse_numbers_values line)]
        (when (or (= x1 x2) (= y1 y2))
          (add-vent-line field1 x1 y1 x2 y2))
        (add-vent-line field2 x1 y1 x2 y2)))
(print (sum-vents field1))
(print (sum-vents field2))
