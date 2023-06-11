require('config.bootstrap')
require('config.options')
require('config.lazy')
require('config.mappings')

pcall(vim.cmd.colorscheme, 'tokyonight-storm')
