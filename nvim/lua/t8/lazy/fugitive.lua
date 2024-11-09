return {
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    config = function()
        vim.api.nvim_set_keymap('n', '<Leader>gy', ':.GBrowse!<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('x', '<Leader>gy', ":GBrowse!<CR>", { noremap = true, silent = true })
        local function get_github_permalink()
            local relative_file_path = vim.fn.fnamemodify(vim.fn.expand('%'), ':.')
            local line_number = vim.fn.line('.')
            local remote_url = vim.fn.system('git config --get remote.origin.url'):gsub('\n', '')
            print("Debug - Remote URL: " .. remote_url)
            local owner, repo
            local patterns = {
                'github.com[:/](.+)/(.+)%.git$',
                'github.com[:/](.+)/(.+)$',
                'git@github.com:(.+)/(.+)%.git$',
                'https://github.com/(.+)/(.+)%.git$',
                'https://github.com/(.+)/(.+)$'
            }
            for _, pattern in ipairs(patterns) do
                owner, repo = remote_url:match(pattern)
                if owner and repo then
                    break
                end
            end
            if not owner or not repo then
                print("Error: Unable to parse GitHub repository information")
                print("Debug - Owner: " .. tostring(owner))
                print("Debug - Repo: " .. tostring(repo))
                return
            end
            local branch = vim.fn.system('git rev-parse --abbrev-ref HEAD'):gsub('\n', '')
            local permalink = string.format('https://github.com/%s/%s/blob/%s/%s#L%d',
                owner, repo, branch, relative_file_path, line_number)
            vim.fn.setreg('+', permalink)
            print("GitHub permalink copied to clipboard: " .. permalink)
        end

        vim.keymap.set('n', '<leader>gl', get_github_permalink,
            { noremap = true, silent = true, desc = 'Get GitHub permalink' })

        local t8_Fugitive = vim.api.nvim_create_augroup("t8_Fugitive", {})

        local autocmd = vim.api.nvim_create_autocmd
        autocmd("BufWinEnter", {
            group = t8_Fugitive,
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                local opts = { buffer = bufnr, remap = false }
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git('push')
                end, opts)

                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git({ 'pull', '--rebase' })
                end, opts)

                vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
            end,
        })

        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
    end
}
