-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.api.nvim_create_user_command("Wq", function()
  local bt = vim.bo.buftype
  local fname = vim.fn.expand("%:p")
  vim.notify("Wq: buftype=[" .. bt .. "] fname=" .. fname, vim.log.levels.INFO)
  if bt == "terminal" then
    vim.cmd("bd")
    return
  end
  if fname ~= "" then
    if bt ~= "" then
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      vim.fn.writefile(lines, fname)
      vim.bo.modified = false
    else
      vim.cmd("w")
    end
  end
  vim.cmd("bd")
end, {})
vim.api.nvim_create_user_command("Q", function(opts)
  if opts.bang then
    vim.cmd("bd!")
  else
    vim.cmd("bd")
  end
end, { bang = true })
vim.cmd("cabbrev wq Wq")
vim.cmd("cabbrev q Q")
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "mermaid",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    vim.keymap.set("n", "<leader>mp", "<cmd>MermaidPreview<CR>", { buffer = buf, desc = "Mermaid Preview" })
    vim.keymap.set("n", "<leader>mf", "<cmd>MermaidFormat<CR>", { buffer = buf, desc = "Mermaid Format" })
  end,
})
-- Wort rückwärts löschen mit Ctrl-Backspace im Insert-Mode
vim.keymap.set("i", "<C-Backspace>", "<C-w>", { noremap = true, silent = true })

-- Altsysteme/Manche Terminals senden <C-h> bei Ctrl-Backspace
vim.keymap.set("i", "<C-h>", "<C-w>", { noremap = true, silent = true })
-- Auto-save nvim-anywhere buffers without prompts
vim.opt.autoread = true
vim.opt.confirm = false

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "/tmp/nvim-anywhere/*",
  callback = function()
    vim.bo.modifiable = true
    vim.bo.readonly = false
  end,
})

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  pattern = "/tmp/nvim-anywhere/*",
  command = "silent! noautocmd write!",
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  pattern = "/tmp/nvim-anywhere/*",
  command = "silent! checktime",
})

vim.api.nvim_create_autocmd("FileChangedShell", {
  pattern = "/tmp/nvim-anywhere/*",
  command = "silent! noautocmd edit!",
})
