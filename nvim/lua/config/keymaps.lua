local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Basic mappings
map('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })
map('n', '<Esc>', ':noh<CR><Esc>', { desc = 'Clear search highlighting' })

-- Line navigation
map('n', 'j', 'gj', { desc = 'Move down by visual line' })
map('n', 'k', 'gk', { desc = 'Move up by visual line' })
map('n', 'H', '^', { desc = 'Go to start of line' })
map('n', 'L', '$', { desc = 'Go to end of line' })

-- System clipboard integration
map('n', '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
map('v', '<leader>y', '"+y', { desc = 'Yank selection to system clipboard' })
map('n', '<leader>Y', '"+Y', { desc = 'Yank line to system clipboard' })
map('n', '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
map('n', '<leader>P', '"+P', { desc = 'Paste from system clipboard before cursor' })

-- Write and quit
map('n', '<leader>ww', ':w<CR>', { desc = 'Write buffer' })
map('n', '<leader>wq', ':wq<CR>', { desc = 'Write buffer and quit' })
map('n', '<leader>qq', ':q<CR>', { desc = 'Quit' })
map('n', '<leader>wa', ':wa<CR>', { desc = 'Write all buffers' })
map('n', '<leader>QQ', ':q!<CR>', { desc = 'Force quit' })
map('n', '<leader>qa', ':qa<CR>', { desc = 'Quit all' })
map('n', '<leader>QA', ':qa!<CR>', { desc = 'Quit all' })

-- File explorer
map('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
map('n', '<leader>E', ':NvimTreeFocus<CR>', { desc = 'Focus file explorer' })

-- Window management
-- Splitting
map('n', '<leader>sv', ':vsplit<CR>', { desc = 'Split vertical' })
map('n', '<leader>sh', ':split<CR>', { desc = 'Split horizontal' })
map('n', '<leader>sc', ':close<CR>', { desc = 'Split close' })

-- Window navigation
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
map('n', 'gb', '<C-o>', { desc = 'Go back' })
map('n', 'gf', '<C-i>', { desc = 'Go forward' })

-- Documentation and errors
map('n', '<leader>hd', vim.lsp.buf.hover, { desc = 'Show documentation' })
map('n', '<leader>he', vim.diagnostic.open_float, { desc = 'Show error description' })

-- Error navigation
map('n', '<leader>ne', vim.diagnostic.goto_next, { desc = 'Go to next error' })
map('n', '<leader>pe', vim.diagnostic.goto_prev, { desc = 'Go to previous error' })map('n', '<leader>hq', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })

-- Code actions
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions' })
map('n', '<leader>fd', vim.lsp.buf.format, { desc = 'Format code' })
map('n', '<leader>fi', vim.lsp.buf.format, { desc = 'Format and organize imports' })

-- Indentation
map('n', '<Tab>', '>>_', { desc = 'Indent line' })
map('n', '<S-Tab>', '<<_', { desc = 'Unindent line' })
map('i', '<S-Tab>', '<C-D>', { desc = 'Unindent in insert mode' })
map('v', '<Tab>', '>gv', { desc = 'Indent selection' })
map('v', '<S-Tab>', '<gv', { desc = 'Unindent selection' })

--- Debugging
map('n', '<F5>', function() require('dap').continue() end, { desc = 'Start/Continue debugging' })
map('n', '<F10>', function() require('dap').step_over() end, { desc = 'Step over' })
map('n', '<F11>', function() require('dap').step_into() end, { desc = 'Step into' })
map('n', '<F12>', function() require('dap').step_out() end, { desc = 'Step out' })
map('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'Toggle breakpoint' })
map('n', '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = 'Set conditional breakpoint' })
map('n', '<leader>dr', function() require('dap').repl.open() end, { desc = 'Open debug REPL' })
map('n', '<leader>dl', function() require('dap').run_last() end, { desc = 'Run last debug configuration' })


-- Method navigation
