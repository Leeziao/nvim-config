return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.buttons.val = {
        dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "  > Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
        dashboard.button("s", "  > Settings", ":e $MYVIMRC<CR>"),
        dashboard.button("q", "  > Quit", ":qa<CR>"),
      }
      local logo = {
        "                           ▒▒▒▒         ",
        "                         ▒▒▒▒▒▒▒▒▒▒     ",
        "                       ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ ",
        "                     ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒",
        "                   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒",
        "  ▒▒▒▒          ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒",
        "▒▒▒▒▒▒▒▒▒     ▒▒▒▒▒▒▒▒▒▒▒▒▒   ▒▒▒▒▒▒▒▒▒▒",
        " ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒      ▒▒▒▒▒▒▒▒▒▒",
        "   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒        ▒▒▒▒▒▒▒▒▒▒",
        "     ▒▒▒▒▒▒▒▒▒▒▒▒▒▒           ▒▒▒▒▒▒▒▒▒▒",
        "   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒        ▒▒▒▒▒▒▒▒▒▒",
        " ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒      ▒▒▒▒▒▒▒▒▒▒",
        "▒▒▒▒▒▒▒▒▒     ▒▒▒▒▒▒▒▒▒▒▒▒▒   ▒▒▒▒▒▒▒▒▒▒",
        "  ▒▒▒▒          ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒",
        "                   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒",
        "                     ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒",
        "                       ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ ",
        "                         ▒▒▒▒▒▒▒▒▒▒     ",
        "                           ▒▒▒▒         ",
      }
      dashboard.section.header.val = logo

      math.randomseed(os.time())

      local function pick_color()
        local colors = { "String", "Identifier", "Keyword", "Number" }
        return colors[math.random(#colors)]
      end
      dashboard.section.header.opts.hl = pick_color()

      alpha.setup(dashboard.opts)
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
  },
  {
    "stevearc/dressing.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("dressing").setup({
        input = {
          relative = "editor",
          title_pos = "center",
          min_width = { 40, 0.4 },
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      presets = {
        operators = true,
        motions = true,
        g = true,
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")
      notify.setup({ stages = "slide" })
      vim.notify = notify
    end,
  },
  {
    "NTBBloodbath/galaxyline.nvim",
    config = function()
      require("galaxyline.themes.eviline")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({})
    end,
  },
  -- {
  --   "shellRaining/hlchunk.nvim",
  --   event = { "UIEnter" },
  --   config = function()
  --     require("hlchunk").setup({})
  --   end,
  -- },
  {
  	"lukas-reineke/indent-blankline.nvim",
  	config = function()
  		vim.cmd([[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
  		vim.cmd([[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
  		vim.cmd([[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
  		vim.cmd([[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]])
  		vim.cmd([[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
  		vim.cmd([[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])

  		vim.opt.list = true
  		vim.opt.listchars:append("space:⋅")
  		vim.opt.listchars:append("eol:↴")

  		require("indent_blankline").setup({
  			space_char_blankline = " ",
  			char_highlight_list = {
  				"IndentBlanklineIndent1",
  				"IndentBlanklineIndent2",
  				"IndentBlanklineIndent3",
  				"IndentBlanklineIndent4",
  				"IndentBlanklineIndent5",
  				"IndentBlanklineIndent6",
  			},
  		})
  	end,
  },
}
