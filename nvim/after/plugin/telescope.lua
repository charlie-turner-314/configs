local ts = require('telescope')
-- setup so find_files will search hidden files too
ts.setup({
    pickers = {
        -- Find files should ignore anything in .git or node_modules
        find_files = {
            hidden = true,
            file_ignore_patterns = {".git", "node_modules"},
        },
    },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({search = vim.fn.input("Grep > ") });
end)
