require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- Your custom mappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Migrating your dap mappings
map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Add breakpoint at line" })
map("n", "<leader>dr", "<cmd> DapContinue <CR>", { desc = "Start or continue the debugger" })

-- Uncomment and adjust the save mapping as needed
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

