require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- You can also specify a list of languages
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true, -- Enable Treesitter highlighting
    additional_vim_regex_highlighting = false,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        ["af"] = "@function.outer", -- Select the outer part of a function
        ["if"] = "@function.inner", -- Select the inner part of a function
        ["ac"] = "@class.outer", -- Select the outer part of a class
        ["ic"] = "@class.inner", -- Select the inner part of a class
      },
    },
  },
}

