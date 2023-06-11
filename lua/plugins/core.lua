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
				"                           ▒▒▒          ",
				"                         ▒▒▒▒▒▒▒▒▒      ",
				"                       ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ",
				"                     ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒",
				"                   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒",
				"  ▒▒▒▒          ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒",
				"▒▒▒▒▒▒▒▒      ▒▒▒▒▒▒▒▒▒▒▒▒▒   ▒▒▒▒▒▒▒▒▒▒",
				" ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒     ▒▒▒▒▒▒▒▒▒▒",
				"   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒        ▒▒▒▒▒▒▒▒▒▒",
				"      ▒▒▒▒▒▒▒▒▒▒▒▒▒           ▒▒▒▒▒▒▒▒▒▒",
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
		"stevearc/resession.nvim",
		config = function()
			local resession = require("resession")
			resession.setup({})
		end,
	},
	{
		"max397574/better-escape.nvim",
		opts = {
			mapping = { "jk" },
			clear_empty_lines = true,
		},
	},
	{
		"akinsho/toggleterm.nvim",
		event = "VeryLazy",
		opts = {
			direction = "float",
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
		dependencies = { "nvim-lua/plenary.nvim" },
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
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
    opts = {
      default_component_configs = {
        icon = {
          folder_empty = "󰜌",
          folder_empty_open = "󰜌",
        },
        git_status = {
          symbols = {
            renamed   = "󰁕",
            unstaged  = "󰄱",
          },
        },
      },
      document_symbols = {
        kinds = {
          File = { icon = "󰈙", hl = "Tag" },
          Namespace = { icon = "󰌗", hl = "Include" },
          Package = { icon = "󰏖", hl = "Label" },
          Class = { icon = "󰌗", hl = "Include" },
          Property = { icon = "󰆧", hl = "@property" },
          Enum = { icon = "󰒻", hl = "@number" },
          Function = { icon = "󰊕", hl = "Function" },
          String = { icon = "󰀬", hl = "String" },
          Number = { icon = "󰎠", hl = "Number" },
          Array = { icon = "󰅪", hl = "Type" },
          Object = { icon = "󰅩", hl = "Type" },
          Key = { icon = "󰌋", hl = "" },
          Struct = { icon = "󰌗", hl = "Type" },
          Operator = { icon = "󰆕", hl = "Operator" },
          TypeParameter = { icon = "󰊄", hl = "Type" },
          StaticMethod = { icon = '󰠄 ', hl = 'Function' },
        }
      },
      -- Add this section only if you've configured source selector.
      source_selector = {
        sources = {
          { source = "filesystem", display_name = " 󰉓 Files " },
          { source = "git_status", display_name = " 󰊢 Git " },
        },
      },
    }
	},
	{
		"NTBBloodbath/galaxyline.nvim",
		config = function()
			require("galaxyline.themes.eviline")
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({})
		end,
	},
}
