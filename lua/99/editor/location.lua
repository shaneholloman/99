--- @class _99.Location
--- @field full_path string
--- @field range _99.Range
--- @field node _99.treesitter.Node
--- @field buffer number
--- @field file_type string
--- @field marks table<string, _99.Mark>
--- @field ns_id string
local Location = {}
Location.__index = Location

--- @param node _99.treesitter.Node
--- @param range _99.Range
function Location.from_ts_node(node, range)
    local full_path = vim.api.nvim_buf_get_name(range.buffer)
    local file_type = vim.bo[range.buffer].ft
    local ns_string = tostring(range.buffer) .. range:to_string()
    local ns_id = vim.api.nvim_create_namespace(ns_string)

    return setmetatable({
        buffer = range.buffer,
        full_path = full_path,
        range = range,
        node = node,
        file_type = file_type,
        marks = {},
        ns_id = ns_id,
    }, Location)
end

function Location:clear_marks()
    for _, mark in pairs(self.marks) do
        mark:delete()
    end
end

return Location
