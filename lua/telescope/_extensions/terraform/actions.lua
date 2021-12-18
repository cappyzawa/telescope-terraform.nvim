local actions = require'telescope.actions'

local Job = require'plenary.job'

local A = {}

local function close_telescope_prompt(prompt_bufnr)
  actions.close(prompt_bufnr)
end

A.remove_state = function(prompt_bufnr)
  local selection = actions.get_selected_entry(prompt_bufnr)
  Job:new({
    command = 'terraform',
    args = {'state', 'rm', selection.value},
    on_exit = function(j, return_val)
      print('deleted terraform state: '.. selection.value)
    end,
  }):sync()
  close_telescope_prompt(prompt_bufnr)
end

return A
