(ns aoc2022.day02
  (:require
    [clojure.string :as str]
    [hyperfiddle.rcf :as rcf]))

(def abc->shape
  {"A" :rock
   "B" :paper
   "C" :scissors})

(def xyz->shape
  {"X" :rock
   "Y" :paper
   "Z" :scissors})

(def shape-points
  {:rock 1
   :paper 2
   :scissors 3})

(def to-lose
  {:rock :scissors
   :scissors :paper
   :paper :rock})

(def to-win
  {:scissors :rock
   :paper :scissors
   :rock :paper})

(defn round-points [a b]
  (cond
    (= a b) 3
    (= (to-win a) b) 6
    (= (to-lose a) b) 0))

(defn game-score [moves]
  (->> moves
       (map (fn [[a b]]
              (+ (shape-points b)
                 (round-points a b))))
       (reduce +)))

(defn choose [a b]
  (case b
    "Y" a
    "X" (to-lose a)
    "Z" (to-win a)))

(defn read-input [file]
  (->> (slurp file)
       (str/split-lines)
       (map (fn [line] (str/split line #"\s+")))))

(defn part1 [moves]
  (->> moves
       (map (fn [[a b]]
              [(abc->shape a)
               (xyz->shape b)]))
       (game-score)))

(defn part2 [moves]
  (->> moves
       (map (fn [[a b]]
              (let [a (abc->shape a)]
                [a (choose a b)])))
       (game-score)))

(rcf/tests
  (def sample (read-input "resources/02s.txt"))
  (def input (read-input "resources/02.txt"))

  (part1 sample) := 15
  (part1 input) := 11449

  (part2 sample) := 12
  (part2 input) := 13187)
