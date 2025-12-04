R("99")

function foo() end

local ns_id = vim.api.nvim_create_namespace("turd-ferg")
local function add_virtual_text()
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    vim.api.nvim_buf_set_extmark(0, ns_id, 2, 0, {
        virt_lines = {
            {
                { "foo bar 1", "Comment" },
            },
            {
                { "foo bar 2", "error" },
            },
            {
                { "foo bar 4", "Comment" },
            },
        },
    })
end

add_virtual_text()
