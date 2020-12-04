(ns day04
  (:require [clojure.string :as str]
            [clojure.set :as set]))

(def mandatory-fields #{:byr :iyr :eyr :hgt :hcl :ecl :pid})

(defn parse-passport [s]
  (->> (str/split s #"\s+")
       (map #(-> (str/split % #":")
                 (update 0 keyword)))
       (into {})))

(defn has-mandatory-fields? [m]
  (->> m (keys) (set) (set/subset? mandatory-fields)))

(defn valid-number? [s min max]
  (try
    (let [y (Integer/parseInt s)]
      (<= min y max))
    (catch Exception _
      false)))

(def ecl? #{"amb" "blu" "brn" "gry" "grn" "hzl" "oth"})

(defn valid-passport? [{:keys [byr iyr eyr hgt hcl ecl pid]}]
  (boolean
   (and (valid-number? byr 1920 2002)
        (valid-number? iyr 2010 2020)
        (valid-number? eyr 2020 2030)
        (when-some [[_ val unit] (some->> hgt (re-matches #"(\d+)(cm|in)"))]
          (case unit
            "cm" (valid-number? val 150 193)
            "in" (valid-number? val 59 76)))
        (some->> hcl (re-matches #"#[0-9a-f]{6}"))
        (ecl? ecl)
        (some->> pid (re-matches #"\d{9}")))))

(defn part1 []
  (->> (-> (slurp "inputs/day04.txt")
           (str/trim)
           (str/split #"\n\n"))
      (map parse-passport)
      (filter has-mandatory-fields?)
      (count)))

(defn part2 []
  (->> (-> (slurp "inputs/day04.txt")
           (str/trim)
           (str/split #"\n\n"))
      (map parse-passport)
      (filter valid-passport?)
      (count)))

(defn -main []
  (println (part1))
  (println (part2)))
