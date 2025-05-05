local api = vim.api
local ts_utils = require "nvim-treesitter.ts_utils"
local parsers = require "nvim-treesitter.parsers"

local M = {}

---@type table<integer, table<TSNode|nil|table>>
local selections = {}

function M.init_selection()
    local buf = api.nvim_get_current_buf()
    local row, col = unpack(api.nvim_win_get_cursor(0))
    selections[buf] = { { type = "cursor", row = row, col = col } }
    parsers.get_parser():parse { vim.fn.line "w0" - 1, vim.fn.line "w$" }
    local node = ts_utils.get_node_at_cursor()
    table.insert(selections[buf], node)
    ts_utils.update_selection(buf, node)
end

function M.node_incremental()
    local buf = api.nvim_get_current_buf()
    selections[buf] = selections[buf] or {}
    if #selections[buf] == 0 then
        local row, col = unpack(api.nvim_win_get_cursor(0))
        table.insert(selections[buf], { type = "cursor", row = row, col = col })
    end
    local nodes = selections[buf]
    local node = nodes[#nodes]
    if not node or (type(node) == "table" and node.type == "cursor") then
        node = ts_utils.get_node_at_cursor()
        table.insert(selections[buf], node)
        ts_utils.update_selection(buf, node)
        return
    end
    local parent = node:parent()
    if parent then
        table.insert(selections[buf], parent)
        ts_utils.update_selection(buf, parent)
    end
end

function M.node_decremental()
    local buf = api.nvim_get_current_buf()
    local nodes = selections[buf]
    if not nodes or #nodes < 2 then return end
    table.remove(selections[buf])
    local node = nodes[#nodes]
    if type(node) == "table" and node.type == "cursor" then
        api.nvim_win_set_cursor(0, { node.row, node.col })
        selections[buf] = nil
        return
    end
    ts_utils.update_selection(buf, node)
end

vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "v:*",
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        selections[buf] = nil
    end,
    desc = "Clear Treesitter incremental selection stack on leaving visual mode",
})

return M
