(var pairs
     {"(" ")"
      "[" "]"
      "{" "}"
      "<" ">"})

(var corruption-points
     {")" 3
      "]" 57
      "}" 1197
      ">" 25137})

(var completion-points
     {")" 1
      "]" 2
      "}" 3
      ">" 4})

(fn is-corrupted [line]
  (var stack {})
  (for [i 1 (length line)]
    (var c (line:sub i i))
    (if
     (. pairs c) (table.insert stack (. pairs c))
     (= c (. stack (length stack))) (table.remove stack)
     (lua "return true, c")))
  (values false stack))

(var corruption-score 0)
(var completion-scores {})
(each [line (io.lines "inputs/day10.txt")]
      (let [(corrupted val) (is-corrupted line)]
        (if corrupted
          (set corruption-score (+ corruption-score (. corruption-points val)))
          (do
            (var line-score 0)
            (for [i (length val) 1 -1]
              (set line-score (+ (* line-score 5)
                                 (. completion-points (. val i)))))
            (table.insert completion-scores line-score)))))

(print corruption-score)
(table.sort completion-scores)
(print (. completion-scores (-> (length completion-scores)
                                (/ 2)
                                (math.ceil))))
