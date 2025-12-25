return {
  {

    "yetone/avante.nvim",
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- provider = "gemini-cli",
      provider = "claude-code",
      acp_providers = {
        ["gemini-cli"] = {
          command = "gemini",
          args = { "--experimental-acp" },
          env = {
            GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
          },
        },
        ["claude-code"] = {
          command = "npx",
          args = { "@zed-industries/claude-code-acp" },
          env = {
            ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY"),
          },
        },
      },
    },
  },
}
