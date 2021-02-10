local terraform_builtin = require'telescope._extensions.ghq_builtin'

return require'telescope'.register_extension{
  exports = {
    state_list = terraform_builtin.state_list
  },
}
