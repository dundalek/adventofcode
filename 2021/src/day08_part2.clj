(ns day08-part2
  (:require [clojure.string :as str]
            [clojure.set :as set]))

(defn calculate-mapping [signals]
  (let [groups (group-by count signals)
        d1 (-> groups (get 2) first)
        d4 (-> groups (get 4) first)
        d7 (-> groups (get 3) first)
        d8 (-> groups (get 7) first)
        d6 (->> (get groups 6)
                (filter #(not= 2 (count (set/intersection d1 %))))
                (first))
        d0 (->> (disj (set (get groups 6)) d6)
                (filter #(not= 4 (count (set/intersection d4 %))))
                (first))
        d9 (-> (set (get groups 6))
               (set/difference #{d0 d6})
               (first))
        d3 (->> (get groups 5)
                (filter #(= 3 (count (set/intersection d7 %))))
                (first))
        d5 (->> (disj (set (get groups 5)) d3)
                (filter #(= 1 (count (set/difference d6 %))))
                (first))
        d2 (-> (set (get groups 5))
               (set/difference #{d3 d5})
               (first))]
    {d0 0
     d1 1
     d2 2
     d3 3
     d4 4
     d5 5
     d6 6
     d7 7
     d8 8
     d9 9}))

(defn -main []
  (->> (slurp "inputs/day08.txt")
       (str/split-lines)
       (map (fn [line]
              (let [tokens (->> (str/split line #"\s+")
                                (map #(set %)))
                    signals (take 10 tokens)
                    digits (drop 11 tokens)
                    mapping (calculate-mapping signals)]
                (->> (map mapping digits)
                     (apply str)
                     (Integer/parseInt)))))
       (reduce +)))

