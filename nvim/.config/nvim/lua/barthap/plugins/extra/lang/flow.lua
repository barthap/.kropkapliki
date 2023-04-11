return {
	-- correctly setup lspconfig
	{
		"neovim/nvim-lspconfig",
		opts = {
			-- make sure mason installs the server
			servers = {
				flow = {
					on_attach = function()
						for _, client_ in pairs(vim.lsp.get_active_clients()) do
							-- stop tsserver if flow is already active
							if client_.name == "tsserver" then
								client_.stop()
							end
						end
					end,
				},
			},
		},
	},
}
