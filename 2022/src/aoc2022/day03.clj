(ns aoc2022.day03
  (:require
   [clojure.set :as set]
   [clojure.string :as str]
   [hyperfiddle.rcf :as rcf]))

(defn read-input [file]
  (->> (slurp file)
       (str/split-lines)))

(def item->priority
  (zipmap (map char (concat (range (int \a) (inc (int \z)))
                            (range (int \A) (inc (int \Z)))))
          (range 1 53)))

(defn calculate-priority [parts]
  (->> parts
       (map set)
       (apply set/intersection)
       (first)
       (item->priority)))

(defn part1 [lines]
  (->> lines
       (map (fn [line] (split-at (/ (count line) 2) line)))
       (map calculate-priority)
       (reduce +)))

(defn part2 [lines]
  (->> lines
       (partition 3)
       (map calculate-priority)
       (reduce +)))

(rcf/tests
 (def sample (read-input "resources/03s.txt"))
 (def input (read-input "resources/03.txt"))

 (part1 sample) := 157
 (part1 input) := 7727

 (part2 sample) := 70
 (part2 input) := 2609)
