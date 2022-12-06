#! /usr/bin/lua

local inspect = require("inspect")

local function all_chars_unique(str)
  local set = {}
  for el = 1, str:len() do
    if set[str:byte(el)] ~= nil then
      set[str:byte(el)] = set[str:byte(el)] + 1
    else
      set[str:byte(el)] = 1
    end
  end

  for _, v in pairs(set) do
    if v > 1 then
      return false
    end
  end
  return true
end

local function find_first_cons_idx(str, n, p)
  for index = 1, str:len() - n do
    if p(str:sub(index, index + n)) then
      return index
    end
  end
end

local function find_first_cons_eidx(str, n, p)
  return find_first_cons_idx(str, n, p) + n - 1
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
  local marker_length <const> = 4
  print(find_first_cons_eidx(data, marker_length, all_chars_unique))
end

main()
