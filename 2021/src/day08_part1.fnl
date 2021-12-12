(var lengths
     {2 true ; 1
      3 true ; 4
      4 true ; 7
      7 true}) ; 8

(var part1 0)
(each [line (io.lines "inputs/day08.txt")]
      (let [it (string.gmatch line "[a-g]+")
            signals {}
            digits {}]
        (for [i 1 10]
          (table.insert signals (it)))
        (for [i 1 4]
          (table.insert digits (it)))
        (each [_ d (ipairs digits)]
              (when (. lengths (length d))
                (set part1 (+ part1 1))))))

(print part1)
