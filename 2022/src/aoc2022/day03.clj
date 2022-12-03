(ns aoc2022.day03
  (:require
   [clojure.set :as set]
   [clojure.string :as str]
   [hyperfiddle.rcf :as rcf]
   [clojure.core.typed :as t]))

;; Unannotated var clojure.core/slurp
(t/ann clojure.core/slurp [t/Str :-> t/Str])

;; split-lines returns Vec, with Seq tc is unhappy, but there seem to be no ISeq
(t/ann read-input [t/Str :-> (t/Vec t/Str)])
(defn read-input [file]
  (->> (slurp file)
       (str/split-lines)))

;; there is not t/Char, it seems primitive classes like Character can be used
(t/ann item->priority (t/Map Character t/Int))
(def item->priority
  (zipmap (map char (concat (range (int \a) (inc (int \z)))
                            (range (int \A) (inc (int \Z)))))
          (range 1 53)))

(t/ann calculate-priority [(t/Seq (t/Seq Character)) :-> (t/Seq t/Int)])
(defn calculate-priority [parts]
  (->> parts
       (map set)
       (apply set/intersection)
       (first)
       (item->priority)))

(t/ann part1 [(t/Vec t/Str) :-> t/Int])
(defn part1 [lines]
  (->> lines
       (map (fn [line] (split-at (/ (count line) 2) line)))
       (map calculate-priority)
       (reduce +)))

(t/ann part2 [(t/Vec t/Str) :-> t/Int])
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

(comment
  ;; Could not make types work, fails on `(->> parts (map set))`
  ;; with Polymorphic function map could not be applied to arguments
  (t/check-ns))
