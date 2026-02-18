local keymap = vim.keymap.set

vim.g.mapleader = " "

-- Format the current buffer

vim.keymap.set("n", "<leader>ff", function()
    require("conform").format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
    })
end, { desc = "Format file" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP Go to Definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "LSP References" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "LSP Implementation" })
vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "LSP Hover" })

vim.keymap.set("n", "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>")
vim.keymap.set("n", "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>")
vim.keymap.set("n", "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>")
vim.keymap.set("n", "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>")
vim.keymap.set("n", "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>")

vim.keymap.set("n", "<leader>sf", "<cmd>FzfLua files<cr>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>sg", "<cmd>FzfLua live_grep<cr>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>sb", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>sh", "<cmd>FzfLua help_tags<cr>", { desc = "Help Tags" })
vim.keymap.set("n", "<leader>sr", "<cmd>FzfLua resume<cr>", { desc = "Resume Last Search" })


vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", { desc = "Go to buffer " .. i })
end
vim.keymap.set("n", "<leader>x", "<cmd>bd!<CR>", { desc = "Close current buffer" })

vim.keymap.set("n", "<leader>tk", "<cmd>split | terminal<CR>", { desc = "Open terminal up" })
local function open_term(cmd)
    vim.cmd(cmd)
    vim.cmd("term")
    vim.cmd("startinsert")
end
vim.keymap.set("n", "<leader>tj", function()
    open_term("belowright split")
end, { desc = "Open terminal down" })
vim.keymap.set("n", "<leader>th", function()
    open_term("vsplit")
end, { desc = "Open terminal left" })
vim.keymap.set("n", "<leader>tl", function()
    open_term("belowright vsplit")
end, { desc = "Open terminal right" })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

vim.keymap.set("n", "<leader>ta", function()
    vim.g.completion_enabled = not vim.g.completion_enabled
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            vim.b[buf].completion = vim.g.completion_enabled
        end
    end
    if vim.g.completion_enabled then
        print("Autocomplete: ON")
    else
        print("Autocomplete: OFF")
    end
end, { desc = "Toggle autocomplete" })

local centered = false
local group_name = "KeepCentered"
local function enable()
    if centered then
        print("Centering: already ON")
        return
    end
    centered = true
    vim.api.nvim_create_augroup(group_name, { clear = true })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "WinEnter", "BufWinEnter", "VimResized" }, {
        group = group_name,
        callback = function()
            vim.cmd("silent! normal! zz")
        end,
    })
    print("Centering: ON")
end

local function disable()
    if not centered then
        print("Centering: already OFF")
        return
    end
    centered = false
    pcall(vim.api.nvim_del_augroup_by_name, group_name)
    print("Centering: OFF")
end

local function toggle()
    if centered then
        disable()
    else
        enable()
    end
end
vim.keymap.set("n", "<leader>z", toggle, { desc = "Toggle cursor centering" })
