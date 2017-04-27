local TAB = "  "
local OUTPUT_FILE = "love_standard.lua"

local function addHeader(output)
  table.insert(output, "local empty, read_write = {}, { read_only = false }")
  table.insert(output, "")
  table.insert(output, "local love = {")
  table.insert(output, TAB .. "read_only = true,")
  table.insert(output, TAB .. "fields = {")
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

local function addModules (output, indent, modules)
  for _, m in pairs(modules) do
    table.insert(output, indent .. m.name .. " = {")
    table.insert(output, indent .. TAB .. "fields = {")

    addFunctions(output, indent .. TAB:rep(2), m.functions)

    table.insert(output, indent .. TAB .. "},")
    table.insert(output, indent .. "},")
  end
end

local function addFooter (output)
  table.insert(output, TAB .. "},")
  table.insert(output, "}")
  table.insert(output, "")
  table.insert(output, "return love")
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
