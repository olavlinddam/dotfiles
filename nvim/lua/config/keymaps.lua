-- stylua: ignore
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

-- Buffers
map('n', '<leader>bw', ':w<CR>', { desc = '[B]uffer write' })
map('n', '<leader>bwq', ':wq<CR>', { desc = '[B]uffer write and quit' })
map('n', '<leader>bq', ':q<CR>', { desc = '[B]uffer quit' })
map('n', '<leader>bwa', ':wa<CR>', { desc = '[B]uffer write all' })
map('n', '<leader>bfq', ':q!<CR>', { desc = '[B]uffer force quit' })
map('n', '<leader>bqa', ':qa<CR>', { desc = '[B]uffer quit all' })
map('n', '<leader>bfqa', ':qa!<CR>', { desc = '[B]uffer force quit all' })
map('n', '<leader>bl', ':e#<CR>', { noremap = true, silent = true, desc = 'Jump to last buffer' })

-- Line navigation
map('n', 'j', 'gj', { desc = 'Move down by visual line' })
map('n', 'k', 'gk', { desc = 'Move up by visual line' })
map('n', 'H', '^', { desc = 'Go to start of line' })
map('n', 'L', '$', { desc = 'Go to end of line' })
map('v', 'j', 'gj', { desc = 'Move down by visual line' })
map('v', 'k', 'gk', { desc = 'Move up by visual line' })
map('v', 'H', '^', { desc = 'Go to start of line' })
map('v', 'L', '$', { desc = 'Go to end of line' })


-- Jumplist
map('n', 'jb', '<C-o>', { desc = '[j]umplist [b]ack' })
map('n', 'jf', '<C-i>', { desc = '[j]umplist [f]orward' })

-- Which Key 
-- This will be conditionally loaded when which-key plugin is available
vim.api.nvim_create_autocmd("User", {
    pattern = "LazyLoad",
    callback = function(ev)
        if ev.data == "which-key.nvim" then
            -- Show buffer local keymaps
            map('n', '<leader>?', function()
                require("which-key").show({ global = false })
            end, { desc = 'Buffer Local Keymaps (which-key)' })

            -- Show all keymaps
            map('n', '<leader>wk', function()
                require("which-key").show({ global = true })
            end, { desc = 'Show All Keymaps' })
        end
    end,
})

-- Persistence
vim.api.nvim_create_autocmd("User", {
    pattern = "LazyLoad",
    callback = function(ev)
        if ev.data == "persistence.nvim" then
            map('n', '<leader>qs', function() require("persistence").load() end, { desc = 'Restore Session' })
            map('n', '<leader>qS', function() require("persistence").select() end, { desc = 'Select Session' })
            map('n', '<leader>ql', function() require("persistence").load({ last = true }) end, { desc = 'Restore Last Session' })
            map('n', '<leader>qd', function() require("persistence").stop() end, { desc = "Don't Save Current Session" })
        end
    end,
})

-- System clipboard integration
map('n', '<leader>y', '"+y', { desc = '[y]ank to system clipboard' })
map('v', '<leader>y', '"+y', { desc = '[Y]ank selection to system clipboard in visual mode' })
map('n', '<leader>Y', '"+Y', { desc = '[Y]ank line to system clipboard' })
map('n', '<leader>p', '"+p', { desc = '[p]aste from system clipboard' })
map('n', '<leader>P', '"+P', { desc = '[P]aste from system clipboard before cursor' })
map('v', '<leader>p', '"+p', { desc = '[p]aste from system clipboard in visual mode' })
map('v', '<leader>P', '"+P', { desc = '[P]aste from system clipboard before cursor in visual mode' })



-- Telescope keymaps (lazy loaded)
vim.api.nvim_create_autocmd("User", {
    pattern = "LazyLoad",
    callback = function(ev)
        if ev.data == "telescope.nvim" then
            local builtin = require 'telescope.builtin'

            map('n', '<leader>ss', builtin.lsp_document_symbols, { desc = '[s]earch [s]ymbols in document' })
            map('n', '<leader>SS', builtin.lsp_dynamic_workspace_symbols, { desc = '[S]ymbols in workspace' })
            map('n', '<leader>sh', builtin.help_tags, { desc = '[s]earch [h]elp' })
            map('n', '<leader>sk', builtin.keymaps, { desc = '[s]earch [k]eymaps' })
            map('n', '<leader>sf', builtin.find_files, { desc = '[s]earch [f]iles' })
            map('n', '<leader>sw', builtin.grep_string, { desc = '[s]earch current [w]ord' })
            map('n', '<leader>sg', builtin.live_grep, { desc = '[s]earch by [g]rep' })
            map('n', '<leader>sd', builtin.diagnostics, { desc = '[s]earch [d]iagnostics' })
            map('n', '<leader>sr', builtin.resume, { desc = '[s]earch [r]esume' })
            map('n', '<leader>s.', builtin.oldfiles, { desc = '[s]earch recent files ("." for repeat)' })
            map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] find existing buffers' })

            -- slightly advanced example of overriding default behavior and theme
            map('n', '<leader>/', function()
                -- you can pass additional configuration to telescope to change the theme, layout, etc.
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, { desc = '[/] fuzzily search in current buffer' })

            -- it's also possible to pass additional configuration options.
            --  see `:help telescope.builtin.live_grep()` for information about particular keys
            map('n', '<leader>s/', function()
                builtin.live_grep {
                    grep_open_files = true,
                    prompt_title = 'live grep in open files',
                }
            end, { desc = '[s]earch [/] in open files' })

            -- shortcut for searching your neovim configuration files
            map('n', '<leader>sn', function()
                builtin.find_files { cwd = vim.fn.stdpath 'config' }
            end, { desc = '[s]earch [n]eovim files' })
        end
    end,
})



-- File explorer
map('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
map('n', '<leader>E', ':NvimTreeFocus<CR>', { desc = 'Focus file explorer' })

-- Window management
-- Splitting
map('n', '<leader>s+', ':vsplit<CR>', { desc = 'Split vertical' })
map('n', '<leader>s-', ':split<CR>', { desc = 'Split horizontal' })

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

-- Lsp
map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
map('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
map('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
map('n', 'gt', vim.lsp.buf.type_definition, { desc = 'Go to type definition' })
map('n', 'hd', vim.lsp.buf.hover, { desc = 'Show documentation' })
map('n', 'he', vim.diagnostic.open_float, { desc = 'Show error description' })


-- Error navigation
map('n', '<leader>dn', vim.diagnostic.goto_next, { desc = '[d]iagnostic [n]ext' })
map('n', '<leader>dp', vim.diagnostic.goto_prev, { desc = '[d]iagnostic [p]revious' })
map('n', '<leader>dq', vim.diagnostic.setloclist, { desc = '[d]iagnostic [q]uicklist' })

-- Code actions
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[r]e[n]ame symbol' })
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[c]ode [a]ctions' })
map('n', '<leader>fd', vim.lsp.buf.format, { desc = '[f]ormat [d]ocument' })
map('n', '<leader>fi', vim.lsp.buf.format, { desc = '[f]ormat [i]mports' })
    --
-- Git 
-- Neogit
map('n', '<leader>gg', function() require('neogit').open() end, { desc = 'Open Neogit' })
map('n', '<leader>gc', function() require('neogit').open({"commit"}) end, { desc = 'Neogit commit' })
map('n', '<leader>gp', function() require('neogit').open({"pull"}) end, { desc = 'Neogit pull' })
map('n', '<leader>gP', function() require('neogit').open({"push"}) end, { desc = 'Neogit push' })
map('n', '<leader>gb', function() require('neogit').open({"branch"}) end, { desc = 'Neogit branch' })
map('n', '<leader>gl', function() require('neogit').open({"log"}) end, { desc = 'Neogit log' })

-- DiffView
map('n', '<leader>gdo', '<cmd>DiffviewOpen<cr>', { desc = 'Open DiffView' })
map('n', '<leader>gdc', '<cmd>DiffviewClose<cr>', { desc = 'Close DiffView' })
map('n', '<leader>gfh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'File History (current file)' })
map('n', '<leader>gph', '<cmd>DiffviewFileHistory<cr>', { desc = 'File History (project)' })

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
map('n', '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
    { desc = 'Set conditional breakpoint' })
map('n', '<leader>dr', function() require('dap').repl.open() end, { desc = 'Open debug REPL' })
map('n', '<leader>dl', function() require('dap').run_last() end, { desc = 'Run last debug configuration' })

