local TAB = "   "
local OUTPUT_FILE = "love_standard.lua"
local MAX_LINE_LENGTH = 100
local MODE = "add" --"luajit"

local function addHeader(output)
  local HEADER = {
    "local empty, read_write = {}, { read_only = false }",
    "",
    "local function def_fields(...)",
    TAB .. "local fields = {}",
    "",
    TAB .. "for _, field in ipairs({...}) do",
    TAB .. TAB .. "fields[field] = empty",
    TAB .. "end",
    "",
    TAB .. "return {fields = fields}",
    "end",
    "",
    "local love = {",
    TAB .. "fields = {"
  }

  if MODE == "luajit" then
    table.insert(HEADER, 14, TAB .. "read_only = true,")
  end

  for _, v in ipairs(HEADER) do
    table.insert(output, v)
  end

  return (TAB):rep(2)
end

local function addFunctions (output, indent, functions)
  for _, f in pairs(functions) do
    table.insert(output, indent .. f.name .. " = empty,")
  end
end

local function addCallbacks (output, indent, functions)
  for _, f in pairs(functions) do
    table.insert(output, indent .. f.name .. " = read_write,")
  end
end

local function getFields (functions, indent, str)
  local fields = {}
  str = indent .. str

  for i=1, #functions, 1 do

    local name = '"'..functions[i].name .. '",'

    if #(str .. name) > MAX_LINE_LENGTH then
      table.insert(fields, str)
      str = indent .. TAB .. name
    else
      str = str .. name
    end
  end

  table.insert(fields, str)
  fields[#fields] = fields[#fields]:sub(1, -2) .. "),"

  return fields
end

local function addModules (output, indent, modules)
  table.insert(output, "")

  for _, m in pairs(modules) do
    local fields = getFields(m.functions, indent, m.name .. " = def_fields(")

    for i=1, #fields do
      table.insert(output, fields[i])
    end

    table.insert(output, "")
  end

  output[#output] = nil
end

local function addFooter (output)
  output[#output] = output[#output]:sub(1, -2)

  local FOOTER = {
    TAB .. "}",
    "}",
    "",
    "return {",
    TAB .. ((MODE == "add") and "read_globals" or "fields") .. " = { love = love }",
    "}",
  }

  for _, v in ipairs(FOOTER) do
    table.insert(output, v)
  end
end


local function createTable (api)
  local output = {}

  local indent = addHeader(output)

  addFunctions(output, indent, api.functions)
  addCallbacks(output, indent, api.callbacks)

  addModules  (output, indent, api.modules  )

  addFooter(output)

  return table.concat(output, "\n")
end

local function write ()
  local api = require("api.love_api")
  assert(api, "No api file found!")
  print("Found API file for LÖVE version " .. api.version)

  local data = createTable(api)

  local file = io.open(OUTPUT_FILE, "w")
  assert(file, "ERROR: Can't write file: " .. OUTPUT_FILE)
  file:write(data)

  print( 'DONE!' )
end

write()
