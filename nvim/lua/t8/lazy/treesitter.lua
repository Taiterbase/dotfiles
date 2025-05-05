return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "vimdoc",
                "javascript",
                "typescript",
                "c",
                "lua",
                "rust",
                "jsdoc",
                "bash",
                "tsx",
                "markdown",
                "markdown_inline",
            },
            sync_install = false,
            auto_install = true,
            indent = {
                enable = true
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { "markdown" },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                    },
                    include_surrounding_whitespace = true,
                },
            },
            --     incremental_selection = {
            --         enable = true,
            --         keymaps = {
            --             node_incremental = "v",
            --             node_decremental = "<M-v>",
            --         },
            --     },
        })

        local visel = require("t8.incremental_selection")
        vim.keymap.set("x", "v", visel.node_incremental, { desc = "TS custom node incremental" })
        vim.keymap.set("x", "<M-v>", visel.node_decremental, { desc = "TS custom node decremental" })

        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

        parser_config.templ = {
            install_info = {
                url = "https://github.com/vrischmann/tree-sitter-templ.git",
                files = { "src/parser.c", "src/scanner.c" },
                branch = "master",
            },
            filetype = "templ",
        }

        parser_config.mdx = {
            install_info = {
                url = "https://github.com/pynappo/tree-sitter-mdx",
                files = { "src/parser.c", "src/scanner.c" },
                branch = "main",
            },
            filetype = "mdx",
        }
    end
}
