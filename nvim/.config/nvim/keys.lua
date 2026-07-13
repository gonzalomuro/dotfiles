-- leader key
vim.g.mapleader = ','

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }
    vim.keymap.set("n", "gd", "<cmd>Obsidian follow_link<CR>", opts)
    vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian open<CR>", opts)
    vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian today<CR>", opts)
    vim.keymap.set("n", "<CR>", "<cmd>Obsidian toggle_checkbox<CR>", opts)
  end,
})

-- Basic
vim.keymap.set({ 'n' }, '<leader>a', ':keepjumps normal! ggVG<cr>')
vim.keymap.set({ 'i' }, '<leader>c', '<Esc>')
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>h', '^')
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>l', 'g_')
vim.keymap.set({ 'n', 'x', 'o' }, '<Tab>', '<cmd>bn<cr>')
vim.keymap.set({ 'n', 'x', 'o' }, '<S-Tab>', '<cmd>bp<cr>')

-- fzf-lua
vim.keymap.set('n', '<leader>b', "<cmd>lua require('fzf-lua').buffers()<cr>", { silent = true })
-- vim.keymap.set('n', '<c-G>', "<cmd>lua require('fzf-lua').live_grep()<cr>", { silent = true })
vim.keymap.set('n', '<leader>f', "<cmd>lua require('fzf-lua').files()<cr>", { silent = true })

