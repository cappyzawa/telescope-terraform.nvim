local has_telescope, telescope = pcall(require, 'telescope')
local terraform_builtin = require'telescope._extensions.terraform.builtin'

if not has_telescope then
  error('This plugin requires nvim-telescope/telescope.nvim')
end

return telescope.register_extension{
  exports = {
    state_list = terraform_builtin.state_list
  },
}
