return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        local map = vim.keymap.set

        -- Existing keymaps with descriptions
        map("n", "<leader>ha", function() harpoon:list():add() end,
            { desc = "[H]arpoon [a]dd file" })

        map("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            { desc = "[H]arpoon [l]ist toggle" })

        -- Navigation keymaps with descriptions
        map("n", "<leader>h1", function() harpoon:list():select(1) end,
            { desc = "[H]arpoon select [1]" })

        map("n", "<leader>h2", function() harpoon:list():select(2) end,
            { desc = "[H]arpoon select [2]" })

        map("n", "<leader>h3", function() harpoon:list():select(3) end,
            { desc = "[H]arpoon select [3]" })

        map("n", "<leader>h4", function() harpoon:list():select(4) end,
            { desc = "[H]arpoon select [4]" })

        -- Toggle previous & next buffers with descriptions
        map("n", "<leader>hp", function() harpoon:list():prev() end,
            { desc = "[H]arpoon [p]revious" })

        map("n", "<leader>hn", function() harpoon:list():next() end,
            { desc = "[H]arpoon [n]ext" })

        -- Remove current file from Harpoon list with description
        map("n", "<leader>hr", function() harpoon:list():remove() end,
            { desc = "[H]arpoon [r]emove file" })
    end,
}
