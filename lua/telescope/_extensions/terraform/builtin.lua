local actions = require'telescope.actions'
local conf = require'telescope.config'.values
local finders = require'telescope.finders'
local from_entry = require'telescope.from_entry'
local make_entry = require'telescope.make_entry'
local pickers = require'telescope.pickers'
local previewers = require'telescope.previewers'
local utils = require'telescope.utils'
local popup = require('plenary.popup')

local terraform_a = require'telescope._extensions.terraform.actions'
local M = {}

M.state_list = function(opts)
  opts = opts or {}
  opts.bin = opts.bin and vim.fn.expand(opts.bin) or 'terraform'
  opts.cwd = utils.get_lazy_default(opts.cwd, vim.loop.cwd)

  local bin = vim.fn.expand(opts.bin)
  local title = 'Terraform States'
  pickers.new(opts, {
    prompt_title = title,
    finder = finders.new_oneshot_job(
      {bin, 'state', 'list'}
    ),
    previewer = previewers.new_termopen_previewer{
      get_command = function(entry)
        local state = from_entry.path(entry)
        return {bin, 'state', 'show', state}
      end,
    },
    sorter = conf.file_sorter(opts),
    attach_mappings = function(_, map)
			map('i', '<CR>', nil)
			map('n', '<CR>', nil)
      map('i','d',terraform_a.remove_state)
      map('n','d',terraform_a.remove_state)
      return true
    end,
    selection = 'reset',
  }):find()
end

return M
