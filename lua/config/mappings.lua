local maps = {
  i = {},
  n = {},
  v = {},
  t = {},
}

local function system_open(path)
  local cmd = { 'xdg-open' }
  vim.print('System Open', vim.fn.expand('<cfile>'))
  vim.fn.jobstart(vim.fn.extend(cmd, { path or vim.fn.expand('<cfile>') }), { detach = true })
end

local function is_available(plugin)
  local success, lazy_config = pcall(require, 'lazy.core.config')
  return success and lazy_config.plugins[plugin] ~= nil
end

local function toggle_term_cmd(opts)
  local terms = globalValues.user_terminals
  -- if a command string is provided, create a basic table for Terminal:new() options
  if type(opts) == "string" then opts = { cmd = opts, hidden = true } end
  local num = vim.v.count > 0 and vim.v.count or 1
  -- if terminal doesn't exist yet, create it
  if not terms[opts.cmd] then terms[opts.cmd] = {} end
  if not terms[opts.cmd][num] then
    if not opts.count then opts.count = vim.tbl_count(terms) * 100 + num end
    if not opts.on_exit then opts.on_exit = function() terms[opts.cmd][num] = nil end end
    terms[opts.cmd][num] = require("toggleterm.terminal").Terminal:new(opts)
  end
  -- toggle the terminal
  terms[opts.cmd][num]:toggle()
end

local sections = {
  f = { desc = "Find" },
  p = { desc = "Packages" },
  l = { desc = "LSP" },
  u = { desc = "UI" },
  d = { desc = "Debugger" },
  S = { desc = "Session" },
  t = { desc = "Terminal" },
}

maps.v['<'] = { "<gv", desc = "Decrease Indentation" }
maps.v['>'] = { ">gv", desc = "Increase Indentation" }

maps.n["j"] = { "v:count == 0 ? 'gj' : 'j'", expr = true, desc = "Move cursor down" }
maps.n["k"] = { "v:count == 0 ? 'gk' : 'k'", expr = true, desc = "Move cursor up" }
maps.n["<leader>w"] = { "<cmd>w<cr>", desc = "Save" }
maps.n["<leader>q"] = { "<cmd>confirm q<cr>", desc = "Quit" }
maps.n["gx"] = { system_open, desc = "Open file under cursor with system app" }
maps.n["|"] = { "<cmd>vsplit<cr>", desc = "Vertical Split" }
maps.n["\\"] = { "<cmd>split<cr>", desc = "Horizontal Split" }

maps.n["<leader>pi"] = { function() require("lazy").install() end, desc = "Plugins Install" }
maps.n["<leader>ps"] = { function() require("lazy").home() end, desc = "Plugins Status" }
maps.n["<leader>pS"] = { function() require("lazy").sync() end, desc = "Plugins Sync" }
maps.n["<leader>pu"] = { function() require("lazy").check() end, desc = "Plugins Check Updates" }
maps.n["<leader>pU"] = { function() require("lazy").update() end, desc = "Plugins Update" }

-- Navigate tabs
maps.n["]t"] = { function() vim.cmd.tabnext() end, desc = "Next tab" }
maps.n["[t"] = { function() vim.cmd.tabprevious() end, desc = "Previous tab" }

if is_available('Comment.nvim') then
    maps.n["<leader>/"] = {
    function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end,
    desc = "Toggle comment line",
  }
  maps.v["<leader>/"] = {
    "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
    desc = "Toggle comment for selection",
  }
end

if is_available "neo-tree.nvim" then
  maps.n["<leader>e"] = { "<cmd>Neotree toggle reveal<cr>", desc = "Toggle Explorer" }
end

if is_available('resession.nvim') then
  local resession = require("resession")
  -- Resession does NOTHING automagically, so we have to set up some keymaps
  maps.n["<leader>Ss"] = { resession.save, desc = "Save session"}
  maps.n["<leader>Sl"] = { resession.load, desc = "Load session" }
  maps.n["<leader>Sd"] = { resession.delete, desc = "Delete Session" }
end

if is_available('telescope.nvim') then
  maps.n["<leader>f<CR>"] = { function() require("telescope.builtin").resume() end, desc = "Resume previous search" }
  maps.n["<leader>f'"] = { function() require("telescope.builtin").marks() end, desc = "Find marks" }
  maps.n["<leader>fa"] = {
    function()
      local cwd = vim.fn.stdpath "config"
      require("telescope.builtin").find_files {
        prompt_title = "Config Files",
        search_dirs = { cwd },
        cwd = cwd,
      } -- call telescope
    end,
    desc = "Find config files",
  }
  maps.n["<leader>fc"] = { function() require("telescope.builtin").commands() end, desc = "Find commands" }
  maps.n["<leader>ff"] = { function() require("telescope.builtin").find_files() end, desc = "Find files" }
  maps.n["<leader>fF"] = {
    function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end,
    desc = "Find all files",
  }
  maps.n["<leader>fh"] = { function() require("telescope.builtin").help_tags() end, desc = "Find help" }
  maps.n["<leader>fk"] = { function() require("telescope.builtin").keymaps() end, desc = "Find keymaps" }
  maps.n["<leader>fm"] = { function() require("telescope.builtin").man_pages() end, desc = "Find man" }
  if is_available "nvim-notify" then
    maps.n["<leader>fn"] =
      { function() require("telescope").extensions.notify.notify() end, desc = "Find notifications" }
  end
  maps.n["<leader>fo"] = { function() require("telescope.builtin").oldfiles() end, desc = "Find history" }
  maps.n["<leader>fr"] = { function() require("telescope.builtin").registers() end, desc = "Find registers" }
  maps.n["<leader>ft"] =
    { function() require("telescope.builtin").colorscheme { enable_preview = true } end, desc = "Find themes" }
  maps.n["<leader>fw"] = { function() require("telescope.builtin").live_grep() end, desc = "Find words" }
  maps.n["<leader>fW"] = {
    function()
      require("telescope.builtin").live_grep {
        additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
      }
    end,
    desc = "Find words in all files",
  }
end

if is_available('nvim-dap') then
  maps.n["<F5>"] = { function() require("dap").continue() end, desc = "Debugger: Start" }
  maps.n["<S-F5>"] = { function() require("dap").terminate() end, desc = "Debugger: Stop" } -- Shift+F5
  maps.n["<C-F5>"] = { function() require("dap").restart_frame() end, desc = "Debugger: Restart" } -- Control+F5
  maps.n["<F6>"] = { function() require("dap").pause() end, desc = "Debugger: Pause" }
  maps.n["<F9>"] = { function() require("dap").toggle_breakpoint() end, desc = "Debugger: Toggle Breakpoint" }
  maps.n["<F10>"] = { function() require("dap").step_over() end, desc = "Debugger: Step Over" }
  maps.n["<F11>"] = { function() require("dap").step_into() end, desc = "Debugger: Step Into" }
  maps.n["<S-F11>"] = { function() require("dap").step_out() end, desc = "Debugger: Step Out" } -- Shift+F11

  maps.n["<leader>db"] = { function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint (F9)" }
  maps.n["<leader>dB"] = { function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints" }
  maps.n["<leader>dc"] = { function() require("dap").continue() end, desc = "Start/Continue (F5)" }
  maps.n["<leader>dC"] = {
    function()
      vim.ui.input({ prompt = "Condition: " }, function(condition)
        if condition then require("dap").set_breakpoint(condition) end
      end)
    end,
    desc = "Conditional Breakpoint (S-F9)",
  }
  maps.n["<leader>di"] = { function() require("dap").step_into() end, desc = "Step Into (F11)" }
  maps.n["<leader>do"] = { function() require("dap").step_over() end, desc = "Step Over (F10)" }
  maps.n["<leader>dO"] = { function() require("dap").step_out() end, desc = "Step Out (S-F11)" }
  maps.n["<leader>dq"] = { function() require("dap").close() end, desc = "Close Session" }
  maps.n["<leader>dQ"] = { function() require("dap").terminate() end, desc = "Terminate Session (S-F5)" }
  maps.n["<leader>dp"] = { function() require("dap").pause() end, desc = "Pause (F6)" }
  maps.n["<leader>dr"] = { function() require("dap").restart_frame() end, desc = "Restart (C-F5)" }
  maps.n["<leader>dR"] = { function() require("dap").repl.toggle() end, desc = "Toggle REPL" }
  maps.n["<leader>ds"] = { function() require("dap").run_to_cursor() end, desc = "Run To Cursor" }

  if is_available "nvim-dap-ui" then
    maps.n["<leader>dE"] = {
      function()
        vim.ui.input({ prompt = "Expression: " }, function(expr)
          if expr then require("dapui").eval(expr) end
        end)
      end,
      desc = "Evaluate Input",
    }
    maps.v["<leader>dE"] = { function() require("dapui").eval() end, desc = "Evaluate Input" }
    maps.n["<leader>du"] = { function() require("dapui").toggle() end, desc = "Toggle Debugger UI" }
    maps.n["<leader>dh"] = { function() require("dap.ui.widgets").hover() end, desc = "Debugger Hover" }
  end
end

if is_available "toggleterm.nvim" then
  if vim.fn.executable "lazygit" == 1 then
    maps.n["<leader>tg"] = { function() toggle_term_cmd "lazygit" end, desc = "ToggleTerm lazygit" }
  end
  local python = vim.fn.executable "ipython" == 1 and "ipython" or
                  vim.fn.executable "python" == 1 and "python" or
                  vim.fn.executable "python3" == 1 and "python3"

  if python then maps.n["<leader>tp"] = { function() toggle_term_cmd(python) end, desc = "ToggleTerm python" } end
  maps.n["<leader>tf"] = { "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" }
  maps.n["<leader>th"] = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal split" }
  maps.n["<leader>tv"] = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical split" }
  maps.n["<F7>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" }
  maps.t["<F7>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" }
end

-- if is_available('trouble.nvim') then
--   maps.n["<leader>ld"] = { "<cmd>TroubleToggle<CR>", desc="Toggle Trouble" }
-- end

if is_available('lspsaga.nvim') then
  maps.n["<leader>lo"] = { "<cmd>Lspsaga outline<CR>", desc="Toggle Outline" }
  maps.n['<leader>lr'] = { '<cmd>Lspsaga rename<CR>', desc="Rename Symbol" }
  maps.n['<leader>la'] = { '<cmd>Lspsaga code_action<CR>', desc="Code Action" }
  maps.n['<leader>lb'] = { '<cmd>Lspsaga show_buf_diagnostics ++normal<CR>', desc="Show Buffer Diagnostics" }
  maps.n['<leader>lw'] = { '<cmd>Lspsaga show_workspace_diagnostics ++normal<CR>', desc="Show Workspace Diagnostics" }
  maps.n['K'] = { '<cmd>Lspsaga hover_doc<CR>', desc="Show hover doc" }

  -- Diagnostic jump
  -- You can use <C-o> to jump back to your previous location
  maps.n["[E"] = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc='Jump to previous diagnostic'}
  maps.n["]E"] = { "<cmd>Lspsaga diagnostic_jump_next<CR>" , desc='Jump to next diagnostic'}

  -- Diagnostic jump with filters such as only jumping to an error
  maps.n["[e"] = { function()
    require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, desc="Jump to previous error"}
  maps.n["]e"] = { function()
    require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, desc = "Jump to next error"}
end

if is_available('code_runner.nvim') then
  maps.n["<leader>n"] = { "<cmd>CodeRunnerAutoRun<CR>", desc="Auto Run Task" }
  maps.n["<leader>lh"] = { "<cmd>CodeRunnerHistory<CR>", desc="History Runned Task" }
end

if is_available('gitsigns.nvim') then
  local gs  = require('gitsigns')
  maps.n['<leader>ub'] = { function() gs.toggle_current_line_blame() end, desc="Toggle Line Blame" }
  maps.n['<leader>ud'] = { function() gs.diffthis() end, desc="Toggle Diff View" }
end

maps.n['<leader>u/'] = { function ()
  vim.opt.formatoptions:remove( {'o', 'c', 'r' })
end, desc="Close Continuous Comments" }

-- LSP configurations
maps.n['<leader>lf'] = { function ()
  vim.lsp.buf.format()
end, desc="Format Buffer" }

maps.n["<C-h>"] = { "<C-w>h", desc = "Move to left split" }
maps.n["<C-j>"] = { "<C-w>j", desc = "Move to below split" }
maps.n["<C-k>"] = { "<C-w>k", desc = "Move to above split" }
maps.n["<C-l>"] = { "<C-w>l", desc = "Move to right split" }
maps.t["<C-h>"] = { "<cmd>wincmd h<cr>", desc = "Terminal left window navigation" }
maps.t["<C-j>"] = { "<cmd>wincmd j<cr>", desc = "Terminal down window navigation" }
maps.t["<C-k>"] = { "<cmd>wincmd k<cr>", desc = "Terminal up window navigation" }
maps.t["<C-l>"] = { "<cmd>wincmd l<cr>", desc = "Terminal right window navigation" }

maps.n["<C-Up>"] = { "<cmd>resize -2<CR>", desc = "Resize split up" }
maps.n["<C-Down>"] = { "<cmd>resize +2<CR>", desc = "Resize split down" }
maps.n["<C-Left>"] = { "<cmd>vertical resize -2<CR>", desc = "Resize split left" }
maps.n["<C-Right>"] = { "<cmd>vertical resize +2<CR>", desc = "Resize split right" }

maps.n['<leader>f'] = sections['f']
maps.n['<leader>p'] = sections['p']
maps.n['<leader>l'] = sections['l']
maps.n['<leader>S'] = sections['S']
maps.n['<leader>t'] = sections['t']
maps.n['<leader>d'] = sections['d']
maps.n['<leader>u'] = sections['u']

local wk_avail, wk = pcall(require, 'which-key')

for mode, map in pairs(maps) do
  for keymap, options in pairs(map) do
    local cmd = options[1]
    options[1] = nil
    if cmd then
      vim.keymap.set(mode, keymap, cmd, options)
    else
      if wk_avail then
        wk.register( { [keymap] = options}, { mode = mode } )
      end
    end
  end
end

vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg='#db0b3c' })
vim.api.nvim_set_hl(0, 'DapLogPoint', { fg='#eaeaeb' })
vim.api.nvim_set_hl(0, 'DapStopped', { fg='#9ecc6a' })

vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl= 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', linehl='DapLogPoint', numhl= 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', numhl='DapStopped' })

