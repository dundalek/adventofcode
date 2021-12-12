
(fn append-edge [edges from to]
  (let [node-edges (or (. edges from) {})]
    (table.insert node-edges to)
    (tset edges from node-edges)))

(var edges {})
(each [line (io.lines "inputs/day12.txt")]
      (let [(from to) (string.match line "(%a+)-(%a+)")]
        (append-edge edges from to)
        (append-edge edges to from)))

(var paths-sum 0)
(var visited {})
(fn traverse [node]
  (each [_ target (ipairs (. edges node))]
        (if
         (= target "end") (set paths-sum (+ paths-sum 1))

         (= target "start") nil

         (string.match target "^%u+$") (traverse target)

         (not (. visited target))
         (do (tset visited target true)
             (traverse target)
             (tset visited target nil)))))

(traverse "start")
(print paths-sum)

(var paths-sum 0)
(var visited {})
(var visited-twice false)
(fn traverse [node]
  (each [_ target (ipairs (. edges node))]
        (if
         (= target "end") (set paths-sum (+ paths-sum 1))

         (= target "start") nil

         (string.match target "^%u+$") (traverse target)

         (not (. visited target))
         (do (tset visited target true)
             (traverse target)
             (tset visited target nil))

         (not visited-twice)
         (do (set visited-twice true)
             (traverse target)
             (set visited-twice false)))))

(traverse "start")
(print paths-sum)
