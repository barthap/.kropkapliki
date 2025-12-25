if false then
  return {}
end

return {
  {
    "barthap/react-compiler-marker.nvim",
    opts = {
      -- babel_plugin_path = "node_modules/babel-plugin-react-compiler",
      success_emoji = "✨",
      error_emoji = "💩",
      enabled = true,
    },
    -- -- Only load for React/TypeScript files
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    init = function()
      vim.keymap.set("n", "<leader>k", function()
        -- vim.lsp.buf.hover() -- Show normal LSP hover
        vim.defer_fn(function()
          vim.cmd("ReactCompilerHover") -- Then show React Compiler info
        end, 100) -- Small delay to let LSP hover appear first
      end, { desc = "Show LSP hover + React Compiler info" })
    end,
    --
    -- NOTE: Below is dev config, should not be required in prod
    --
    -- dir = "/Users/barthap/dev/temp/react-compiler-marker",
    -- name = "react-compiler-marker",
    -- config = function(opts)
    --   require("react-compiler-marker").setup(opts)
    -- end,
  },
}
