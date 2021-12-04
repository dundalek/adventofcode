(local utils (dofile "src/utils.lua"))

(var numbers (utils.iter_to_table (io.lines "inputs/day03.txt")))

(fn count_one_bits [nums position]
  (var cnt 0)
  (each [_ num (ipairs nums)]
        (let [c (string.byte num position)]
          (set cnt (+ cnt (if (= c 49) 1 -1)))))
  cnt)

(fn calculate_one_majority [nums position]
  (>= (count_one_bits nums position) 0))

(fn calculate_zero_majority [nums position]
  (< (count_one_bits nums position) 0))

(fn calculate_rate [nums calculate_majority]
  (var rate "")
  (for [i 1 (length (. nums 1))]
    (set rate (.. rate (if (calculate_majority nums i) "1" "0"))))
  (tonumber rate 2))

(var gamma (calculate_rate numbers calculate_one_majority))
(var epsilon (calculate_rate numbers calculate_zero_majority))
(print (* gamma epsilon))

(fn filter [f tbl]
  (local ret {})
  (each [_ x (ipairs tbl)]
        (if (f x) (table.insert ret x)))
  ret)

(fn calculate_rating [numbers calculate_majority]
  (var nums numbers)
  (for [i 1 (length (. nums 1))]
    (let [x (calculate_majority nums i)
          target (if x 49 48)]
      (set nums (filter (fn [x] (= target (string.byte x i))) nums))
      (if (= 1 (length nums))
        (lua "return tonumber(nums[1], 2)")))))

(var generator (calculate_rating numbers calculate_one_majority))
(var scrubber (calculate_rating numbers calculate_zero_majority))
(print (* generator scrubber))
