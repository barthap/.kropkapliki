local M = {}

function M.setup(_)
  -- local dap_install = require "dap-install"
  -- dap_install.config("codelldb", {})
  local dap = require "dap"
  dap.configurations.rust = {
		{
			name = "Launch file",
			type = "rt_lldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false, -- dont do this
		},
	}
end

return M
