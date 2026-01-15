local Agents = require("99.extensions.agents")
local SOURCE = "99"

--- @param _99 _99.State
--- @return _99.Agents.Rule[]
local function rules(_99)
  return Agents.rules_to_items(Agents.rules(_99))
end

--- @class CmpSource
--- @field _99 _99.State
--- @field items _99.Agents.Rule[]
local CmpSource = {}
CmpSource.__index = CmpSource

--- @param _99 _99.State
function CmpSource.new(_99)
  return setmetatable({
    _99 = _99,
    items = rules(_99),
  }, CmpSource)
end

function CmpSource:is_available()
  return true
end

function CmpSource:get_debug_name()
  return SOURCE
end

function CmpSource:get_keyword_pattern()
  return [[@\k\+]]
end

function CmpSource:get_trigger_characters()
  return { "@" }
end

--- @class CompletionItem
--- @field label string
--- @field kind number kind is optional but gives icons / categories
--- @field documentation string can be a string or markdown table
--- @field detail string detail shows a right-side hint

--- @class Completion
--- @field items CompletionItem[]
--- @field isIncomplete boolean -
-- true: I might return more if user types more
-- false: this result set is complete
function CmpSource:complete(params, callback)
  local before = params.context.cursor_before_line or ""
  local items = {} --[[ @as CompletionItem[] ]]

  if #before > 1 and before:sub(#before - 1) ~= " @" then
    callback({
      items = {},
      isIncomplete = false,
    })
    return
  end

  for _, item in ipairs(self.items) do
    table.insert(items, {
      label = item.name,
      insertText = item.path,
      filterText = item.name,
      kind = 17, -- file
      -- documentation = "here is the documentation and everything associated with it",
      -- detail = "detail: right side hint",
    })
  end

  callback({
    items = items,
    isIncomplete = false,
  })
end

--- TODO: Look into what this could be
function CmpSource:resolve(completion_item, callback)
  callback(completion_item)
end

function CmpSource:execute(completion_item, callback)
  callback(completion_item)
end

--- @type CmpSource | nil
local source = nil

--- @param _99 _99.State
local function init_for_buffer(_99)
  local cmp = require("cmp")
  cmp.setup.buffer({
    sources = {
      { name = SOURCE },
    },
  })
end

--- @param _99 _99.State
local function init(_99)
  assert(
    source == nil,
    "the source must be nil when calling init on an completer"
  )

  local cmp = require("cmp")
  source = CmpSource.new(_99)
  cmp.register_source(SOURCE, source)
end

--- @param _99 _99.State
local function refresh_state(_99)
  source.items = rules(_99)
end

--- @type _99.Extensions.Source
local source_wrapper = {
  init_for_buffer = init_for_buffer,
  init = init,
  refresh_state = refresh_state,
}
return source_wrapper
