# telescope-terraform.nvim

`telescope-terraform` is an extension for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) that provides info of your terraform workspace.

![preview](https://github.com/cappyzawa/terraform-lab/blob/main/s/assests/ss.png?raw=true)

## Installation

```lua
use{
  'cappyzawa/telescope-terraform.nvim',
  requires = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require'telescope'.load_extension'terraform'
  end,
}
```

## Usage

Now supports `terraform state list` only.

### list

`:Telescope terraform state_list`

#### Key mappings

|key| usage |
|:---:|:---|
|`d`| remove the selected state |
