(var neighbours
     [[0 -1]
      [0 1]
      [-1 0]
      [1 0]])

(fn get [grid y x]
  (let [row (. grid y)]
    (when row
      (. row x))))

(fn hash-coords [y x]
  (.. y "," x))

(fn count [tbl]
  (var sum 0)
  (each [_ _ (pairs tbl)]
        (set sum (+ sum 1)))
  sum)

(fn is-lowpoint [grid y x]
  (let [val (. grid y x)]
    (each [_ coords (ipairs neighbours)]
          (let [neighbour (get grid
                               (+ y (. coords 1))
                               (+ x (. coords 2)))]
            (when (and neighbour (>= val neighbour))
              (lua "return false")))))
  true)

(fn find-basin [grid basin y x]
  (tset basin (hash-coords y x) true)
  (let [val (. grid y x)]
    (each [_ coords (ipairs neighbours)]
          (let [ny (+ y (. coords 1))
                nx (+ x (. coords 2))
                neighbour (get grid ny nx)]
            (when (and neighbour
                       (not= neighbour 9)
                       (< val neighbour))
              (find-basin grid basin ny nx))))))

(var grid {})
(each [line (io.lines "inputs/day09.txt")]
      (var row {})
      (for [i 1 (length line)]
        (table.insert row (- (string.byte line i) 48)))
      (table.insert grid row))

(var risk 0)
(each [y row (ipairs grid)]
      (each [x val (ipairs row)]
            (when (is-lowpoint grid y x)
              (set risk (+ risk 1 val)))))
(print risk)

(var basins {})
(each [y row (ipairs grid)]
      (each [x val (ipairs row)]
            (when (is-lowpoint grid y x)
              (let [basin {}]
                (find-basin grid basin y x)
                (table.insert basins (count basin))))))
(table.sort basins (fn [a b] (> a b)))
(print (* (. basins 1)
          (. basins 2)
          (. basins 3)))

