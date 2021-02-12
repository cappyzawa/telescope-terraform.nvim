local actions = require'telescope.actions'
local conf = require'telescope.config'.values
local finders = require'telescope.finders'
local from_entry = require'telescope.from_entry'
local make_entry = require'telescope.make_entry'
local pickers = require'telescope.pickers'
local previewers = require'telescope.previewers'
local utils = require'telescope.utils'
local popup=require'popup'

local terraform_a = require'telescope._extensions.terraform_actions'

-- referred by https://github.com/nvim-telescope/telescope-github.nvim/blob/master/lua/telescope/_extensions/gh_builtin.lua#L37
local function msgLoadingPopup(msg,cmd,complete_fn)
  local row = math.floor((vim.o.lines-5) / 2)
  local width = math.floor(vim.o.columns / 1.5)
  local col = math.floor((vim.o.columns - width) / 2)
  for _ = 1 , (width-#msg)/2 , 1 do
    msg = " "..msg
  end
  local prompt_win, prompt_opts = popup.create(msg, {
    border ={},
    borderchars = conf.borderchars ,
    height = 5,
    col = col,
    line = row,
    width = width,
  })
  vim.api.nvim_win_set_option(prompt_win, 'winhl', 'Normal:TelescopeNormal')
  vim.api.nvim_win_set_option(prompt_win, 'winblend', 0)
  local prompt_border_win = prompt_opts.border and prompt_opts.border.win_id
  if prompt_border_win then vim.api.nvim_win_set_option(prompt_border_win, 'winhl', 'Normal:TelescopePromptBorder') end
  vim.defer_fn(vim.schedule_wrap(function()
    local results = utils.get_os_command_output(cmd)
    complete_fn(results)
  end),10)
end

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
      map('i','r',terraform_a.state_rm)
      return true
    end,
    selection = 'reset',
  }):find()
end

return M
