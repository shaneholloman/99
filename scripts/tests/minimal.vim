" covers all package managers i am willing to cover
set rtp+=.
set rtp+=../plenary.nvim
set rtp+=../nvim-treesitter
set rtp+=~/.vim/plugged/plenary.nvim
set rtp+=~/.vim/plugged/nvim-treesitter
set rtp+=~/.local/share/nvim/site/pack/packer/start/plenary.nvim
set rtp+=~/.local/share/nvim/site/pack/packer/start/nvim-treesitter
set rtp+=~/.local/share/lunarvim/site/pack/packer/start/plenary.nvim
set rtp+=~/.local/share/lunarvim/site/pack/packer/start/nvim-treesitter
set rtp+=~/.local/share/nvim/lazy/plenary.nvim
set rtp+=~/.local/share/nvim/lazy/nvim-treesitter

set autoindent
set tabstop=4
set expandtab
set shiftwidth=4
set noswapfile

runtime! plugin/plenary.vim
runtime! plugin/nvim-treesitter.lua

lua <<EOF
local required_parsers = { "lua", "typescript", "go"}

local function missing_parsers(parsers)
  local missing = {}
  local buf = vim.api.nvim_create_buf(false, true) -- false: no list, true: scratch buffer
  for _, lang in ipairs(parsers) do
    local ok = pcall(vim.treesitter.get_parser, buf, lang)
    if not ok then
      table.insert(missing, lang)
    end
  end
  vim.api.nvim_buf_delete(buf, { force = true })
  return missing
end

local to_install = missing_parsers(required_parsers)
if #to_install > 0 then
  -- fixes 'pos_delta >= 0' error - https://github.com/nvim-lua/plenary.nvim/issues/52
  vim.cmd("set display=lastline")

  -- Only attempt installation if nvim-treesitter provided the command.
  if vim.fn.exists(":TSInstallSync") == 2 then
    -- make "TSInstall*" available
    vim.cmd("runtime! plugin/nvim-treesitter.vim")
    vim.cmd("TSInstallSync " .. table.concat(to_install, " "))
  end

  -- Re-check and fail fast with a helpful message.
  local still_missing = missing_parsers(required_parsers)
  if #still_missing > 0 then
    error(
      "Missing Tree-sitter parsers: "
        .. table.concat(still_missing, ", ")
        .. "\nInstall them via :TSInstallSync <langs> or ensure nvim-treesitter is on runtimepath."
    )
  end
end
EOF
