local M = {}

local function configure()
  -- local dap_install = require "dap-install"
  -- dap_install.setup {
  --   installation_path = vim.fn.stdpath "data" .. "/dapinstall/",
  -- }

  local dap_breakpoint = {
    error = {
      text = "🟥",
      texthl = "LspDiagnosticsSignError",
      linehl = "",
      numhl = "",
    },
    rejected = {
      text = "",
      texthl = "LspDiagnosticsSignHint",
      linehl = "",
      numhl = "",
    },
    stopped = {
      text = "⭐️",
      texthl = "LspDiagnosticsSignInformation",
      linehl = "DiagnosticUnderlineInfo",
      numhl = "LspDiagnosticsSignInformation",
    },
  }

  vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
  vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
  vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)
end

local function configure_exts()
  require("nvim-dap-virtual-text").setup {
    commented = true,
  }

  local dap, dapui = require "dap", require "dapui"
  dapui.setup {} -- use default
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

M.config_paths = {"./.nvim-dap/nvim-dap.lua", "./.nvim-dap.lua", "./.nvim/nvim-dap.lua"}

--- @param opts? { silent?: boolean }
local function search_project_config(opts)
    if not pcall(require, "dap") then
        vim.notify("Could not find nvim-dap", vim.log.levels.ERROR, nil)
        return
    end
    local project_config = ""
    for _, p in ipairs(M.config_paths) do
        local f = io.open(p)
        if f ~= nil then
            f:close()
            project_config = p
            break
        end
    end
    if project_config == "" then
        return
    end
  if opts and opts.silent ~= true then
    vim.notify("Found DAP configuration at " .. project_config, vim.log.levels.INFO, nil)
  end
    -- require('dap').adapters = (function() return {} end)()
    -- require('dap').configurations = (function() return {} end)()
    vim.cmd(":luafile " .. project_config)
end


--- @param opts? { silent?: boolean }
local function configure_debuggers(opts)
  require("barthap.config.dap.lua").setup(opts)
  require("barthap.config.dap.rust").setup(opts)
  -- require("config.dap.python").setup()
  -- require("config.dap.go").setup()

  -- Project specific configurations 
  search_project_config(opts)
end

function M.setup()
  configure() -- Configuration
  configure_exts() -- Extensions
  configure_debuggers() -- Debugger
  require("barthap.config.dap.keymaps").setup() -- Keymaps
end

function M.continue()
  local dap = require "dap"
  if dap.session() == nil then
    -- Reload configuration here so it applies potential changes
    -- changes to per-project config without reloading nvim
    configure_debuggers({ silent = true })
  end
  dap.continue()
end

return M
