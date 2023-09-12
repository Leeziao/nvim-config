return {
	{
		"Leeziao/code_runner.nvim",
		config = function()
			require("code_runner").setup({
				launchers = {
					{
						name = "Ask AI",
						pattern = function(self)
              if self.is_runnerable == nil then
                self.is_runnerable = vim.fn.executable("ask") and true or false
              end
              return self.is_runnerable
						end,
            priority = 50,
						cmd = function(self, cb)
              local question = ''
							vim.ui.input({
								prompt = "Question to AI",
							}, function(input)
								if not input or input == "" then
									return
								end
								question = "ask --handler Plain " .. vim.fn.shellescape(input)
                cb({name = "ASK AI", cmd = question})
							end)
              return question
						end,
					},
				},
			})
		end,
	},
}
