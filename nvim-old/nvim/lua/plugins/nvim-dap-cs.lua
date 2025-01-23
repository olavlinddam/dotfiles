return{
        'nicholasmata/nvim-dap-cs', 
        dependencies = { 'mfussenegger/nvim-dap' },
        config = function()
                local dapcs = require("dap-cs").setup({

        dap_configurations = {
    {
      -- Must be "coreclr" or it will be ignored by the plugin
      type = "coreclr",
      name = "Attach remote",
      mode = "remote",
      request = "attach",
    },
  },
  netcoredbg = {
    -- the path to the executable netcoredbg which will be used for debugging.
    -- by default, this is the "netcoredbg" executable on your PATH.
    path = "netcoredbg" 
  }
                })

        end,
}
