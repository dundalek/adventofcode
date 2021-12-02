local pos = 0
local depth = 0
for line in io.lines("inputs/day02.txt") do
  local command, value = string.gmatch(line, "(%w+) (%d+)")()
  value = tonumber(value)
  if command == "forward" then
    pos = pos + value
  elseif command == "down" then
    depth = depth + value
  elseif command == "up" then
    depth = depth - value
  end
end

print(pos * depth)

pos = 0
depth = 0
local aim = 0
for line in io.lines("inputs/day02.txt") do
  local command, value = string.gmatch(line, "(%w+) (%d+)")()
  value = tonumber(value)
  if command == "forward" then
    pos = pos + value
    depth = depth + aim * value
  elseif command == "down" then
    aim = aim + value
  elseif command == "up" then
    aim = aim - value
  end
end

print(pos * depth)
