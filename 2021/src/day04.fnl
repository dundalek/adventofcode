(local utils (dofile "src/utils.lua"))

(fn parse_board [lines_it]
  (when (lines_it)
    (var rows {})
    (for [i 1 5]
      (->> (lines_it)
           (utils.parse_numbers)
           (utils.iter_to_table)
           (table.insert rows)))
    rows))

(fn init_marks [n]
  (var marks {})
  (for [i 1 n]
    (let [rows {}]
      (for [j 1 5]
        (table.insert rows {}))
      (table.insert marks rows)))
  marks)

(fn is_winning [mark row column]
  (var winning_row true)
  (var winning_column true)
  (for [i 1 5]
    (when (not (. mark row i))
      (set winning_row false))
    (when (not (. mark i column))
      (set winning_column false)))
  (or winning_row winning_column))

(fn draw [board mark number]
  (for [i 1 5]
    (for [j 1 5]
      (when (= number (. board i j))
        (tset mark i j true)
        (when (is_winning mark i j)
          (lua "return true"))))))

(fn get_unmarked_sum [board mark]
  (var sum 0)
  (for [i 1 5]
    (for [j 1 5]
      (when (not (. mark i j))
        (set sum (+ sum (. board i j))))))
  sum)

(fn key_count [tbl]
  (accumulate [sum 0
               _ _ (pairs tbl)]
              (+ sum 1)))

(var lines_it (io.lines "inputs/day04.txt"))
(var draws (utils.iter_to_table (utils.parse_numbers (lines_it))))
(var boards (utils.iter_to_table
             (fn [] (parse_board lines_it))))

(fn solve_a []
  (var marks (init_marks (length boards)))
  (each [_ n (ipairs draws)]
        (for [i 1 (length boards)]
          (let [board (. boards i)
                mark (. marks i)]
            (when (draw board mark n)
              (let [score (* n (get_unmarked_sum board mark))]
                (lua "return score")))))))

(fn solve_b []
  (var marks (init_marks (length boards)))
  (var winning_boards {})
  (each [_ n (ipairs draws)]
        (for [i 1 (length boards)]
          (let [board (. boards i)
                mark (. marks i)]
            (when (draw board mark n)
              (tset winning_boards i true)
              (when (= (key_count winning_boards)
                       (length boards))
                (let [score (* n (get_unmarked_sum board mark))]
                  (lua "return score"))))))))

(print (solve_a))
(print (solve_b))
