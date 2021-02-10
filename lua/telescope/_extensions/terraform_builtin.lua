local actions = require'telescope.actions'
local conf = require'telescope.config'.values
local entry_display = require'telescope.pickers.entry_display'
local finders = require'telescope.finders'
local from_entry = require'telescope.from_entry'
local path = require'telescope.path'
local pickers = require'telescope.pickers'
local previewers = require'telescope.previewers'
local utils = require'telescope.utils'

local M = {}

M.state_list = function(opts)
  opts = opts or {}
  opts.bin = 'terraform'
  opts.cwd = utils.get_lazy_default(opts.cwd, vim.loop.cwd)

  local bin = vim.fn.expand(opts.bin)
  pickers.new{
    prompt_title = "Terraform States",
    finder = finders.new_oneshot_job(
      {bin, 'state', 'list'},
      opts
    ),
  }
end

return M
