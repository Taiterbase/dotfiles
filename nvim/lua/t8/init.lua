require("t8.remap")
require("t8.set")
require("t8.lazy_init")
require("gitlinker").setup()

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.have_nerd_font = true

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

vim.filetype.add({
    extension = {
        templ = 'templ',
        mdx = 'mdx',
    },
})

autocmd("TextYankPost", {
    group = augroup("HighlightYank", {}),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 50 })
    end,
})

autocmd("LspAttach", {
    group = augroup("LspStart", {}),
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
    end
})

autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        require('go.format').goimports()
    end,
    group = augroup("goimports", {}),
})

autocmd("BufWritePre", {
    pattern = "*.lua",
    callback = function()
        vim.lsp.buf.format()
    end,
    group = augroup("lua_format", {}),
})

autocmd("BufWritePre", {
    pattern = "*.rs",
    callback = function()
        vim.lsp.buf.format()
    end,
    group = augroup("rustfmt", {}),
})

autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        vim.lsp.buf.format()
    end,
    group = augroup("black", {}),
})

autocmd("BufWritePre", {
    pattern = "*.tf",
    callback = function()
        vim.lsp.buf.format()
    end,
    group = augroup("terraform_fmt", {}),
})
