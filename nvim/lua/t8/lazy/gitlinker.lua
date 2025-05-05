return {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("gitlinker").setup({
            mappings = "gy",
            callbacks = {
                [".*"] = function(url_data)
                    url_data.host = "github.com"
                    return require("gitlinker.hosts").get_github_type_url(url_data)
                end,
                ["github.com"] = require("gitlinker.hosts").get_github_type_url,
                ["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
                ["bitbucket.org"] = require("gitlinker.hosts").get_bitbucket_type_url,
            },
        })
    end,
}
