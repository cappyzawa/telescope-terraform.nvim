local conf = require'telescope.config'.values
local finders = require'telescope.finders'
local pickers = require'telescope.pickers'
local previewers = require'telescope.previewers'
local utils = require'telescope.utils'
local putils = require'telescope.previewers.utils'

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
    layout_config = {
      horizontal = {
        preview_cutoff = 100,
        width = 0.9,
        height = 0.9,
      }
    },
    finder = finders.new_oneshot_job(
      {bin, 'state', 'list'}
    ),
    previewer = previewers.new_buffer_previewer{
      get_buffer_by_name = function (_, entry)
        return entry.value
      end,
      define_preview = function (self, entry, status)
        local command = { bin, 'state', 'show', '-no-color', entry.value }
        putils.job_maker(command, self.state.bufnr, {
          value = entry.value,
          bufname = self.state.bufname,
          cwd = opts.cwd,
        })
      end
    },
    sorter = conf.generic_sorter(opts),
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
