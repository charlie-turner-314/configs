local lsp = require('lsp-zero')
local lspconfig = require('lspconfig')

lsp.preset("recommended")

lsp.ensure_installed({
	'tsserver',
	'eslint',
})


local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Insert}
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({select = true}),
    -- make the tab key select the next item and also insert it at the same time
    ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        else
            fallback()
        end
    end, { 'i', 's' }),
	['<C-Space>'] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
	mapping=cmp_mappings
})

lsp.on_attach(function(client, bufnr)
	local opts = {buffer = bufnr, remap =false}
	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<Leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<Leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<Leader>vca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<Leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<Leader>vrn", function() vim.lsp.buf.refname() end, opts)

    if client.name == 'omnisharp' then
        local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
        for i, v in ipairs(tokenModifiers) do
            v = v:gsub(' ', '_')
            v = v:gsub('%-', '_')
            v = v:gsub('___', '_')
            tokenModifiers[i] = v
        end
        local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
        for i, v in ipairs(tokenTypes) do
            v = v:gsub(' ', '_')
            v = v:gsub('%-', '_')
            v = v:gsub('___', '_')
            tokenTypes[i] = v
        end
    end
    -- If its a tex file: set <leader>of to build and open the pdf
    --  e.g if working on foo.tex, <leader>of will and open foo.pdf
    if client.name == 'texlab' then
        vim.keymap.set("n", "<Leader>of", function()
            vim.lsp.buf.format()
            vim.cmd("silent !pdflatex -interaction=nonstopmode -shell-escape %:r.tex")
            vim.cmd("silent !open %:r.pdf")
        end, opts)
        function FixColors()
            vim.cmd('colorscheme polar');
            vim.cmd('hi! MatchParen cterm=NONE,bold gui=NONE,bold  guibg=#eee8d5 guifg=NONE')
        end
        -- run that with leader + fc
        vim.keymap.set("n", "<Leader>fc", FixColors, opts)
    end
end)


lsp.format_on_save({
    format_opts = {
        async = true,
        timeout_ms = 5000,
    },
    servers = {
        ['omnisharp'] = {'cs'},
        ['texlab'] = {'tex'},
        ['tsserver'] = {'js', 'jsx', 'ts', 'tsx'},
        ['eslint'] = {'js', 'jsx', 'ts', 'tsx'},
    }
})

lsp.configure('texlab', {
-- setup to use latexindent to format
    settings = {
        texlab = {
            build = {
                args = {"--shell-escape"},
                executable = 'pdflatex',
                onSave = false,
            },
            chktex = {
                onEdit = false,
                onOpenAndSave = true,
            },
            forwardSearch = {
                executable = 'zathura',
                onSave = false,
            },
            latexindent = {
                modifyLineBreaks = true
            },
        },
    },
})

lspconfig.emmet_ls.setup({
    filetypes = {'html', 'ejs', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact'},
})

lspconfig.html.setup({
    filetypes = {'html', 'ejs'},
})

lsp.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»'
})

lsp.setup()
