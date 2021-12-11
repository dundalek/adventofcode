(var grid-size 10)

(fn increment-neighbours [grid center-y center-x]
  (for [y (math.max 1 (- center-y 1)) (math.min grid-size (+ center-y 1))]
    (for [x (math.max 1 (- center-x 1)) (math.min grid-size (+ center-x 1))]
      (let [val (. grid y x)]
        (when (not= 0 val)
          (tset grid y x (+ val 1)))))))

(fn check-all-flashing [grid]
  (each [y row (ipairs grid)]
        (each [x val (ipairs row)]
              (when (not= val 0)
                (lua "return false"))))
  true)

(var grid {})
(each [line (io.lines "inputs/day11.txt")]
      (var row {})
      (for [i 1 (length line)]
        (table.insert row (- (string.byte line i) 48)))
      (table.insert grid row))

(var flash-count 0)
(for [i 1 1000]
  (each [y row (ipairs grid)]
        (each [x val (ipairs row)]
              (tset grid y x (+ val 1))))

  (while true
    (var flash-count-before flash-count)
    (each [y row (ipairs grid)]
          (each [x val (ipairs row)]
                (when (> val 9)
                  (set flash-count (+ flash-count 1))
                  (tset grid y x 0)
                  (increment-neighbours grid y x))))
    (when (= flash-count flash-count-before)
      (lua "break")))

  (when (= i 100)
    (print flash-count))
  (when (check-all-flashing grid)
    (print i)
    (lua "return")))
