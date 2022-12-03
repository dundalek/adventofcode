(ns aoc2022.day01
  (:require
    [clojure.string :as str]
    [hyperfiddle.rcf :as rcf]))

(defn read-input [file]
  (->> (slurp file)
       (str/split-lines)
       (map parse-long)
       (partition-by nil?)
       (remove (comp nil? first))))

(defn part1 [items]
  (->> items
       (map #(apply + %))
       (apply max)))

(defn part2 [items]
  (->> items
       (map #(apply + %))
       (sort)
       (reverse)
       (take 3)
       (apply +)))

(rcf/tests
  (def sample (read-input "resources/01s.txt"))
  (def input (read-input "resources/01.txt"))

  (part1 sample) := 24000
  (part1 input) := 71023

  (part2 sample) := 45000
  (part2 input) := 206289)

