local M = {}

local softwares = {
  "git",
  "rg",
  { "fd", "fdfind" },
  "lazygit",
  "gsed",
  "lolcat", -- this one is for kitku
}

function M.check()

  if vim.fn.has("nvim-0.8.0") == 1 then
    vim.health.report_ok("Using Neovim >= 0.8.0")
  else
    vim.health.report_error("Neovim >= 0.8.0 is required")
  end
  vim.health.report_start("External tools")

  for _, cmd in ipairs(softwares) do
    local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
    local commands = type(cmd) == "string" and { cmd } or cmd
    ---@cast commands string[]
    local found = false

    for _, c in ipairs(commands) do
      if vim.fn.executable(c) == 1 then
        name = c
        found = true
      end
    end

    if found then
      vim.health.report_ok(("`%s` is installed"):format(name))
    else
      vim.health.report_warn(("`%s` is not installed"):format(name))
    end
  end
end

return M

