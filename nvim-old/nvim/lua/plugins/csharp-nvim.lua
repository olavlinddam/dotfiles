return {
  "iabdelkareem/csharp.nvim",
  dependencies = {
    "williamboman/mason.nvim", -- Required, automatically installs omnisharp
    "mfussenegger/nvim-dap",
    "Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
  },
  config = function()
    local csharp = require("csharp")
    
    -- If using Roslyn, you might not need Mason's Omnisharp setup
    -- Comment out or remove the following line if not needed
    -- require("mason").setup()
    
    csharp.setup({
      omnisharp = {
        use_roslyn = true, -- Ensure Roslyn is used instead of Mason's Omnisharp
      },
    })
  end,
}

