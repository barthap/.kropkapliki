local Util = require("lazy.core.util")

-- There's a PR for this: https://github.com/simrat39/rust-tools.nvim/pull/346
local hints_enabled = false
local function toggle_inlay_hints()
  require('rust-tools').inlay_hints.toggle()
  -- local inlay_hints =  require('rust-tools').inlay_hints
  -- if hints_enabled then
  --   inlay_hints.disable()
  -- else
  --   inlay_hints.enable()
  -- end
  -- hints_enabled = not hints_enabled
  -- Util.info("Inlay hints " .. (hints_enabled and "enabled" or "disabled"), { title = "Rust tools" })
end

return {

	-- add rust to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "rust" })
			end
		end,
	},
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "codelldb")
    end,
  },
  -- add rust-tools
  {
    "simrat39/rust-tools.nvim",
    dependencies = {{ "folke/neoconf.nvim", cmd = "Neoconf", config = true }, "nvim-lua/plenary.nvim", "rust-lang/rust.vim" },
    ft = { "rust" },
    -- config = function()
      -- require("rust-tools").setup(opts)
    -- end,
  },

	-- correctly setup lspconfig
	{
		"neovim/nvim-lspconfig",
    dependencies = { "simrat39/rust-tools.nvim" },
		opts = {
			-- make sure mason installs the server
			servers = {
				rust_analyzer = {
					settings = {
						imports = {
							granularity = {
								group = "module",
							},
							prefix = "self",
						},
						cargo = {
							buildScripts = {
								enable = true,
							},
						},
						procMacro = {
							enable = true,
						},
					},
				},
			},
      setup = {
        rust_analyzer = function(_, opts)
          local dbg_path = require("mason-registry").get_package("codelldb"):get_install_path()
          local codelldb_path = dbg_path .. "/extension/adapter/codelldb"
          -- TODO: Make .so for linux
          local liblldb_path = dbg_path .. "/extension/lldb/lib/liblldb.dylib"
          print("codelldb_path: " .. codelldb_path)
          local setup_opts = {
            server = opts,
            dap = {
              adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
            },
            tools = {
              inlay_hints = {
                auto = false,
                highlight = "BufferLineHintDiagnosticVisible",
              },
            },
          }
          -- setup_opts.dap.adapter.port = "54321"
          require("rust-tools").setup(setup_opts)

          -- local keymap = {
          --   u = {
          --     h = { toggle_inlay_hints, "Rust inlay hints" },
          --   },
          -- }
          -- require("which-key").register(keymap, {
          --   mode = "n",
          --   prefix = "<leader>",
          --   buffer = nil,
          --   silent = true,
          --   noremap = true,
          --   nowait = false,
          -- })

          -- This is very important. If its false, then the config will be overriden by the default one
         return true
        end,
      },
    },
  },
}
