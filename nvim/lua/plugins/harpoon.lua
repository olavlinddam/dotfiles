return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()
        
        local map = vim.keymap.set
        
        -- Existing keymaps
        map("n", "<leader>ha", function() harpoon:list():add() end)
        map("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        
        -- Navigation keymaps
        map("n", "<leader>h1", function() harpoon:list():select(1) end)
        map("n", "<leader>h2", function() harpoon:list():select(2) end)
        map("n", "<leader>h3", function() harpoon:list():select(3) end)
        map("n", "<leader>h4", function() harpoon:list():select(4) end)
        
        -- Toggle previous & next buffers
        map("n", "<leader>hp", function() harpoon:list():prev() end)
        map("n", "<leader>hn", function() harpoon:list():next() end)
        
        -- New: Remove current file from Harpoon list
        map("n", "<leader>hr", function() 
            harpoon:list():remove() 
        end)
    end,
}
