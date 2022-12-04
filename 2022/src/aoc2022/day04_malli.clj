(ns aoc2022.day04-malli
  (:require
   [clojure.string :as str]
   [hyperfiddle.rcf :as rcf]
   [malli.core :as m]
   [malli.instrument :as mi]))

;; Inspired by https://github.com/skazhy/advent/blob/master/src/haskell/2022/Day4.hs

(m/=> parse-pair [:=> [:cat :string] [:tuple :int :int]])
(defn parse-pair [pair]
  (mapv parse-long (str/split pair #"-")))

(m/=> parse-row [:=> [:cat :string] [:tuple [:tuple :int :int] [:tuple :int :int]]])
(defn parse-row [line]
  (->> (str/split line #",")
       (mapv parse-pair)))

(m/=> read-input [:=> [:cat :string] [:sequential [:tuple [:tuple :int :int] [:tuple :int :int]]]])
(defn read-input [file]
  (->> (slurp file)
       (str/split-lines)
       (map parse-row)))

(m/=> subset? [:=> [:cat [:tuple :int :int] [:tuple :int :int]] :boolean])
(defn subset? [[a1 b1] [a2 b2]]
  (and (>= a1 a2)
       (<= b1 b2)))

(m/=> overlaps? [:=> [:cat [:tuple :int :int] [:tuple :int :int]] :boolean])
(defn overlaps? [[_a1 b1] [a2 b2]]
  (and (>= b1 a2)
       (<= b1 b2)))

(m/=> pair-matches [:=> [:cat [:=> [:cat [:tuple :int :int] [:tuple :int :int]] :boolean]]
                    [:=> [:cat [:tuple [:tuple :int :int] [:tuple :int :int]]] :boolean]])
(defn pair-matches [pred?]
  (fn [[a b]]
    (or (pred? a b)
        (pred? b a))))

(m/=> part1 [:=> [:cat [:sequential [:tuple [:tuple :int :int] [:tuple :int :int]]]] :int])
(defn part1 [items]
  (->> items
       (filter (pair-matches subset?))
       (count)))

(m/=> part2 [:=> [:cat [:sequential [:tuple [:tuple :int :int] [:tuple :int :int]]]] :int])
(defn part2 [items]
  (->> items
       (filter (pair-matches overlaps?))
       (count)))

(rcf/tests
 (mi/instrument!)

 (def sample (read-input "resources/04s.txt"))
 (def input (read-input "resources/04.txt"))

 (part1 sample) := 2
 (part1 input) := 526

 (part2 sample) := 4
 (part2 input) := 886)

(comment

  ;; Wrong argument types
  (read-input 123)

  (pair-matches "abc")

  ;; OK
  (pair-matches subset?)

  ;; This should be OK, but seems to fail with `Insufficient input` for some reason
  (subset? [1 2] [3 4])

  ;; emit clj-kondo type-annotations
  ((requiring-resolve 'malli.clj-kondo/emit!)))
