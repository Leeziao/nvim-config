local options = {
	o = {
		number = true,
		relativenumber = true,
		tabstop = 2,
		shiftwidth = 2,
    clipboard = "unnamedplus", -- Connection to the system clipboard
		smartcase = true,
		expandtab = true,
		termguicolors = true,
		cursorline = true,
		cmdheight = 1,
		wrap = false,
		foldenable = true, -- enable fold for nvim-ufo
    foldlevel = 99, -- set high foldlevel for nvim-ufo
    foldlevelstart = 99, -- start with all code unfolded
    foldcolumn = vim.fn.has "nvim-0.9" == 1 and "1" or nil, -- show foldcolumn in nvim 0.9
    fileencoding = 'utf-8',
    timeoutlen = 500,
	},
	g = {
		mapleader = ' ',
		maplocalleader = ',',
	}
}

for scope, table in pairs(options) do
	for setting, value in pairs(table) do
		vim[scope][setting] = value
	end
end

