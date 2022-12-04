(ns aoc2022.day04
  (:require
   [clojure.string :as str]
   [hyperfiddle.rcf :as rcf]))

(defn read-input [file]
  (->> (slurp file)
       (str/split-lines)
       (map (fn [line]
              (->> (str/split line #",")
                   (mapv (fn [pair]
                           (mapv parse-long
                            (str/split pair #"-")))))))))

(defn part1 [items]
  (->> items
       (filter (fn [[a b]]
                 (let [span [(min (first a) (first b))
                             (max (second a) (second b))]]
                    (or (= a span)
                        (= b span)))))
       (count)))

(defn part2 [items]
  (->> items
       (filter (fn [[a b]]
                 (let [low (max (first a) (first b))
                       high (min (second a) (second b))]
                   (<= low high))))
       (count)))

(rcf/tests
 (def sample (read-input "resources/04s.txt"))
 (def input (read-input "resources/04.txt"))

 (part1 sample) := 2
 (part1 input) := 526

 (part2 sample) := 4
 (part2 input) := 886)
