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
-- Fensterbreite und -höhe in 10er-Schritten ändern
vim.keymap.set("n", "<C-Left>", ":vertical resize -10<CR>", { silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +10<CR>", { silent = true })
vim.keymap.set("n", "<C-Up>", ":resize +10<CR>", { silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -10<CR>", { silent = true })
-- Aliase für Tippfehler bei der Shift-Taste
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("Qa", "qa", {})
require("jupynium").setup({
  -- Hier sagst du Jupynium, dass es das Python aus deiner uv-Umgebung nutzen soll:
  python_host = vim.fn.expand("$HOME/.virtualenvs/jupynium/bin/python"),

  -- Falls dein 'jupyter' Befehl ebenfalls in dieser Umgebung liegt (empfohlen):
  jupyter_command = vim.fn.expand("$HOME/.virtualenvs/jupynium/bin/jupyter"),

  -- Alle anderen Standardeinstellungen können so bleiben:
  auto_attach_to_server = {
    enable = true,
    file_pattern = { "*.ju.*" },
  },
  use_default_keybindings = false,
})
-- 2. Eigene Keybindings mit "j"-Präfix definieren
-- Wir nutzen <space>j als neuen Startpunkt für Jupynium-Befehle

-- Zellen ausführen (alt: <space>x -> neu: <space>jx)
vim.keymap.set(
  { "n", "x" },
  "<space>jx",
  "<cmd>JupyniumExecuteSelectedCells<CR>",
  { desc = "Jupynium: Zellen ausführen" }
)

-- Zell-Output löschen (alt: <space>c -> neu: <space>jc)
vim.keymap.set(
  { "n", "x" },
  "<space>jc",
  "<cmd>JupyniumClearSelectedCellsOutputs<CR>",
  { desc = "Jupynium: Output löschen" }
)

-- Im Notebook scrollen (alt: <space>js -> neu: <space>jjs)
vim.keymap.set("n", "<space>jjs", "<cmd>JupyniumScrollToCell<CR>", { desc = "Jupynium: Zu Zelle scrollen" })

-- Zum Output scrollen (alt: <space>os -> neu: <space>jos)
vim.keymap.set("n", "<space>jos", "<cmd>JupyniumScrollToOutput<CR>", { desc = "Jupynium: Zum Output scrollen" })

-- Variable inspizieren / Hover (alt: <space>K -> neu: <space>jK)
vim.keymap.set("n", "<space>jK", "<cmd>JupyniumKernelHover<CR>", { desc = "Jupynium: Variable inspizieren" })

-- Output-Scrollen umschalten (alt: <space>jo -> neu: <space>jjo)
vim.keymap.set(
  "n",
  "<space>jjo",
  "<cmd>JupyniumToggleSelectedCellsOutputsScroll<CR>",
  { desc = "Jupynium: Output Scroll toggle" }
)

--- 3. Textobjects anpassen (Zellauswahl) ---
-- Hier legen wir ein 'j' vor das 'a' oder 'i' (z.B. v j a j)

-- Gehe zu vorheriger / nächster Zelle (alt: [j / ]j -> neu: [jj / ]jj)
vim.keymap.set(
  { "n", "x", "o" },
  "[jj",
  "<cmd>JupyniumGotoPreviousCellSeparator<CR>",
  { desc = "Jupynium: Vorherige Zelle" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "]jj",
  "<cmd>JupyniumGotoNextCellSeparator<CR>",
  { desc = "Jupynium: Nächste Zelle" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "<space>jjj",
  "<cmd>JupyniumGotoCurrentCellSeparator<CR>",
  { desc = "Jupynium: Aktuelle Zelle" }
)

-- Ganze Zelle markieren/löschen/ändern (Beispiel: v j a j statt v a j)
-- "jaj" = herum um die Zelle (mit Trenner)
vim.keymap.set(
  { "x", "o" },
  "jaj",
  "<cmd>lua require('jupynium.textobj').select_cell(true, false, v.count)<CR>",
  { desc = "Jupynium: outer cell" }
)
-- "jij" = innerhalb der Zelle (ohne Trenner)
vim.keymap.set(
  { "x", "o" },
  "jij",
  "<cmd>lua require('jupynium.textobj').select_cell(false, false, v.count)<CR>",
  { desc = "Jupynium: inner cell" }
)
-- "jaJ" = inklusive dem nächsten Trenner
vim.keymap.set(
  { "x", "o" },
  "jaJ",
  "<cmd>lua require('jupynium.textobj').select_cell(true, true, v.count)<CR>",
  { desc = "Jupynium: outer cell incl. next" }
)
-- "jiJ" = innerhalb inklusive nächstem Trenner
vim.keymap.set(
  { "x", "o" },
  "jiJ",
  "<cmd>lua require('jupynium.textobj').select_cell(false, true, v.count)<CR>",
  { desc = "Jupynium: inner cell incl. next" }
)
-- JupyniumStartSync -> <space>jss
vim.keymap.set("n", "<space>jss", "<cmd>JupyniumStartSync<CR>", { desc = "Jupynium: Synchronisation starten" })

-- JupyniumStartAndAttachToServer -> <space>jsi
vim.keymap.set(
  "n",
  "<space>jsi",
  "<cmd>JupyniumStartAndAttachToServer<CR>",
  { desc = "Jupynium: Server starten und verbinden" }
)
vim.keymap.set("n", "<space>jsd", "<cmd>JupyniumStopSync<CR>", { desc = "Jupynium: Stop synchronization" })

-- Auto-delete nested terminal buffers (term:// inside term://) that appear when
-- running `nvim -c 'terminal'` from within a fish shell in a terminal buffer.
vim.api.nvim_create_autocmd("BufAdd", {
  pattern = "term://*",
  callback = function()
    local name = vim.api.nvim_buf_get_name(0)
    if name:find('fish -c "nvim -c \'terminal\'"', 1, true) then
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(0) then
          vim.api.nvim_buf_delete(0, { force = true })
        end
      end)
    end
  end,
})
