local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Yank and pase
vim.keymap.set('n', '<leader>y', '"+y', { noremap = true, desc = 'Yank to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, desc = 'Yank selection to system clipboard' })
vim.keymap.set('n', '<leader>yy', '"+Y', { noremap = true, desc = 'Yank line to system clipboard' })

vim.keymap.set('n', '<leader>p', '"+p', { noremap = true, desc = 'Paste from system clipboard' })
vim.keymap.set('n', '<leader>P', '"+P', { noremap = true, desc = 'Paste from system clipboard before cursor' })


-- Write and quit
map('n', '<leader>ww', ':w<CR>', { desc = 'Write buffer' })
map('n', '<leader>wq', ':wq<CR>', { desc = 'Write buffer and quit' })
map('n', '<leader>qq', ':q<CR>', { desc = 'Quit' })
map('n', '<leader>wa', ':wa<CR>', { desc = 'Write all buffers' })
map('n', '<leader>QQ', ':q!<CR>', { desc = 'Force quit' })
map('n', '<leader>qa', ':qa<CR>', { desc = 'Quit all' })

-- Telescope keymaps (lazy loaded)
vim.api.nvim_create_autocmd("User", {
    pattern = "LazyLoad",
    callback = function(ev)
        if ev.data == "telescope.nvim" then
            local telescope = require('telescope.builtin')
            map('n', '<leader>ff', telescope.find_files, { desc = 'Find files' })
            map('n', '<leader>fg', telescope.live_grep, { desc = 'Live grep' })
            map('n', '<leader>fb', telescope.buffers, { desc = 'Buffers' })
            map('n', '<leader>fh', telescope.help_tags, { desc = 'Help tags' })
        end
    end,
})

-- File explorer
map('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
map('n', '<leader>E', ':NvimTreeFocus<CR>', { desc = 'Focus file explorer' })

-- Window management
-- Splitting
map('n', '<leader>sv', ':vsplit<CR>', { desc = 'Split vertical' })
map('n', '<leader>sh', ':split<CR>', { desc = 'Split horizontal' })
map('n', '<leader>sc', ':close<CR>', { desc = 'Split close' })

-- Window navigation (optional, but recommended)
map('n', '<C-h>', '<C-w>h', { desc = 'Navigate to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Navigate to window below' })
map('n', '<C-k>', '<C-w>k', { desc = 'Navigate to window above' })
map('n', '<C-l>', '<C-w>l', { desc = 'Navigate to right window' })

-- Window resizing
map('n', '<C-Up>', ':resize +2<CR>', { desc = 'Increase window height' })
map('n', '<C-Down>', ':resize -2<CR>', { desc = 'Decrease window height' })
map('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window width' })
map('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase window width' })


-- Code Navigation
map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
map('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
map('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
map('n', 'gt', vim.lsp.buf.type_definition, { desc = 'Go to type definition' })

-- Documentation
map('n', 'K', vim.lsp.buf.hover, { desc = 'Show hover documentation' })
map('n', '<leader>k', vim.lsp.buf.signature_help, { desc = 'Show signature help' })

-- Error navigation and diagnostics
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
map('n', '<leader>he', vim.diagnostic.open_float, { desc = 'Show diagnostic error messages' })
map('n', '<leader>hq', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })

-- Code actions
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions' })
map('n', '<leader>f', vim.lsp.buf.format, { desc = 'Format code' })
map('n', '<leader>qf', vim.lsp.buf.code_action, { desc = 'Show code actions' })
