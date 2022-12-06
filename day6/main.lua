#! /usr/bin/lua

local inspect = require("inspect")

local function all_chars_unique(str)
  local set = {}
  for el = 1, str:len() do
    local b = str:byte(el)
    if set[b] ~= nil then
      set[b] = set[b] + 1
    else
      set[b] = 1
    end
  end

  -- print(str, inspect(set))
  for _, v in pairs(set) do
    if v > 1 then
      return false
    end
  end
  return true
end

local function find_first_cons_idx(str, n, p)
  for index = 1, str:len() - n do
    if p(str:sub(index, index + n - 1)) then
      return index
    end
  end
  return -1
end

local function find_first_cons_eidx(str, n, p)
  local idx = find_first_cons_idx(str, n, p)
  if idx ~= -1 then return idx + n - 1 else return -1 end
end

local function readfile(filename)
  local infile = io.open(filename, "r")
  if not infile then
    return
  end

  local data = infile:read("a")
  infile:close()
  return data
end

local function main()
  --
  local data = readfile("in.txt")
  local marker_length_p1 <const> = 4
  local marker_length_p2 <const> = 14
  print("Part 1:", find_first_cons_eidx(data, marker_length_p1, all_chars_unique))
  print("Part 2:", find_first_cons_eidx(data, marker_length_p2, all_chars_unique))
end

main()
