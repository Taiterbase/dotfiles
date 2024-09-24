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
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
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

local function set_cursor()
    vim.opt.guicursor = {
        'n-v-c:block-Cursor/lCursor',
        'i-ci-ve:ver25-Cursor/lCursor',
        'r-cr:hor20',
        'o:hor50'
    }

    if vim.env.TERM_PROGRAM == "WarpTerminal" then
        vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
            callback = function()
                vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
            end
        })
        vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
            callback = function()
                vim.opt.guicursor = "a:ver25"
            end
        })
    else
        vim.opt.termguicolors = true
        vim.cmd [[
      let &t_SI = "\e[6 q"
      let &t_SR = "\e[4 q"
      let &t_EI = "\e[2 q"
    ]]
    end
end

set_cursor()
