local Window = require("99.window")
Window.clear_active_popups()
R("99")

local Ext = require("99.extensions")
local _99 = require("99")
_99.setup({
    completion = {
        source = "cmp",
        custom_rules = {
            "scratch/custom_rules"
        }
    }
})
Ext.setup_buffer(_99.__get_state())
