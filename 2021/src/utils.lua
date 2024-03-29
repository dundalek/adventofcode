local M = {}

function M.num_iter(filename)
  local f = io.open(filename)
  return function()
    local num = f:read("*n")
    if num then
      return num
    else
      f:close()
    end
  end
end

function M.iter_to_table(iter)
  local tbl = {}
  for x in iter do
    table.insert(tbl, x)
  end
  return tbl
end

-- function M.read_nums_to_table(filename)
--   local ret = {}
--   for n in M.num_iter(filename) do
--     table.insert(ret, n)
--   end
--   return ret
-- end

function M.read_file(filename)
  local f = io.open(filename)
  local input = f:read("*a")
  f:close()
  return input
end

function M.parse_numbers(input)
  local matches = string.gmatch(input, "%d+")
  return function()
    local match = matches()
    if match then
      return tonumber(match)
    end
  end
end

function M.read_nums_to_table(filename)
  return M.iter_to_table(M.parse_numbers(M.read_file(filename)))
end


function M.parse_numbers_values(input)
  return unpack(M.iter_to_table(M.parse_numbers(input)))
end

return M
