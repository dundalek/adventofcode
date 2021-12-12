(local utils (dofile "src/utils.lua"))

(fn sum-difference [crabs index]
  (var sum 0)
  (each [_ x (ipairs crabs)]
        (set sum (+ sum (math.abs (- x index)))))
  sum)

(fn part2 [crabs index]
  (var sum 0)
  (each [_ x (ipairs crabs)]
        (let [d (math.abs (- x index))]
          (set sum (+ sum (/ (* d (+ d 1)) 2)))))
  sum)

(var crabs (utils.read_nums_to_table "inputs/day07.txt"))

(var idx nil)
(var minval math.huge)
(for [i (math.min (unpack crabs)) (math.max (unpack crabs))]
  (let [val (part2 crabs i)]
    (when (< val minval)
      (set minval val)
      (set idx i))
    (print i val idx minval)))

(print minval)
