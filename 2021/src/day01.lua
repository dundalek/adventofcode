local utils = dofile("src/utils.lua")

local prev = nil
local increased_sum = 0
for n in utils.num_iter("inputs/day01.txt") do
  if prev and n > prev then
    increased_sum = increased_sum + 1
  end
  prev = n
end

print(increased_sum)

prev = nil
increased_sum = 0
local nums = utils.read_nums_to_table("inputs/day01.txt")
for i = 1, table.maxn(nums) - 2 do
  local measurement = nums[i] + nums[i + 1] + nums [i + 2]
  if prev and measurement > prev then
    increased_sum = increased_sum + 1
  end
  prev = measurement
end

print(increased_sum)
