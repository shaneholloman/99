local _99 = require("99")

local M = {}

--- @param list string[]
--- @param value string
--- @return number
local function index_of(list, value)
  for i, item in ipairs(list) do
    if item == value then
      return i
    end
  end
  return 1
end

--- @param provider _99.Providers.BaseProvider?
function M.select_model(provider)
  provider = provider or _99.get_provider()

  provider.fetch_models(function(models, err)
    if err then
      vim.notify("99: " .. err, vim.log.levels.ERROR)
      return
    end
    if not models or #models == 0 then
      vim.notify("99: No models available", vim.log.levels.WARN)
      return
    end

    local ok, pickers = pcall(require, "telescope.pickers")
    if not ok then
      vim.notify(
        "99: telescope.nvim is required for this extension",
        vim.log.levels.ERROR
      )
      return
    end

    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local current = _99.get_model()

    pickers
      .new({}, {
        prompt_title = "99: Select Model (current: " .. current .. ")",
        default_selection_index = index_of(models, current),
        finder = finders.new_table({ results = models }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            if not selection then
              return
            end
            _99.set_model(selection[1])
            vim.notify("99: Model set to " .. selection[1])
          end)
          return true
        end,
      })
      :find()
  end)
end

function M.select_provider()
  local ok, pickers = pcall(require, "telescope.pickers")
  if not ok then
    vim.notify(
      "99: telescope.nvim is required for this extension",
      vim.log.levels.ERROR
    )
    return
  end

  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local providers = _99.Providers
  local names = {}
  local lookup = {}
  for name, provider in pairs(providers) do
    table.insert(names, name)
    lookup[name] = provider
  end
  table.sort(names)

  local current = _99.get_provider()._get_provider_name()

  pickers
    .new({}, {
      prompt_title = "99: Select Provider (current: " .. current .. ")",
      default_selection_index = index_of(names, current),
      finder = finders.new_table({ results = names }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if not selection then
            return
          end
          local chosen = lookup[selection[1]]
          _99.set_provider(chosen)
          vim.notify(
            "99: Provider set to "
              .. selection[1]
              .. " (model: "
              .. _99.get_model()
              .. ")"
          )
        end)
        return true
      end,
    })
    :find()
end

return M
