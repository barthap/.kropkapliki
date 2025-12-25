return {
  -- DAP
  {
    "mfussenegger/nvim-dap",
    event = "BufReadPre",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "nvim-telescope/telescope-dap.nvim",
      -- Language-specific
      "jbyuki/one-small-step-for-vimkind", -- lua
      -- "mfussenegger/nvim-dap-python",
    },
    config = function()
      require("barthap.config.dap").setup()
    end,
  }
}
