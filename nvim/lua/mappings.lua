require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- betterTerm
local betterTerm = require "betterTerm"
-- toggle firts term
vim.keymap.set({ "n", "t" }, "<C-;>", betterTerm.open, { desc = "Open terminal" })
-- Select term focus
vim.keymap.set({ "n" }, "<leader>tt", betterTerm.select, { desc = "Select terminal" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

vim.keymap.set("n", "<leader>rr", ":RunCode<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rf", ":RunFile<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rft", ":RunFile tab<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rp", ":RunProject<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rc", ":RunClose<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>crf", ":CRFiletype<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>crp", ":CRProjects<CR>", { noremap = true, silent = false })

--  ▗▄▄▖▗▄▄▖
-- ▐▌   ▐▌ ▐▌
-- ▐▌   ▐▛▀▘
-- ▝▚▄▄▖▐▌

-- Quick compile and run (C++)
-- Show output in terminal
vim.keymap.set("n", "<F5>", ":w<CR>:!cd %:p:h && g++ -o %:t:r %:t && ./%:t:r < input.txt<CR>")

-- Save output to file
vim.keymap.set("n", "<F6>", ":w<CR>:!cd %:p:h && g++ -o %:t:r %:t && ./%:t:r < input.txt > output.txt <CR>")

-- Compare with expected output
vim.keymap.set(
  "n",
  "<F7>",
  ":w<CR>:!cd %:p:h && g++ -o %:t:r %:t && ./%:t:r < input.txt > output.txt && diff -u -B expected.txt output.txt<CR>"
)

local function setup_problem(name)
  local dir = name or vim.fn.input "Problem name: "
  if dir == "" then
    return
  end

  -- Create directory and files
  vim.cmd("!mkdir -p " .. dir)
  vim.cmd("!touch " .. dir .. "/" .. dir .. ".cpp")
  vim.cmd("!touch " .. dir .. "/input.txt")
  vim.cmd("!touch " .. dir .. "/output.txt")
  vim.cmd("!touch " .. dir .. "/expected.txt")
  vim.cmd("cd " .. dir)
  vim.cmd("edit " .. dir .. ".cpp")
end

vim.keymap.set("n", "<leader>np", function()
  setup_problem()
end)

-- Perfect contest layout
local function contest_layout()
  local current_file = vim.fn.expand "%:p"
  local current_dir = vim.fn.expand "%:p:h"

  -- Only proceed if we're in a cpp file
  if vim.fn.expand "%:e" ~= "cpp" then
    print "Please open a .cpp file first"
    return
  end

  -- vim.cmd "tabnew"
  vim.cmd("edit " .. current_file)
  vim.cmd("vsplit " .. current_dir .. "/input.txt")
  vim.cmd "vertical resize 30"
  vim.cmd("split " .. current_dir .. "/output.txt")
  vim.cmd("split " .. current_dir .. "/expected.txt")
  vim.cmd "wincmd h" -- Go back to the cpp file
end

vim.keymap.set("n", "<leader>cl", contest_layout)

function ResizeContestLayout()
  -- Go to the leftmost window (.cpp)
  vim.cmd "wincmd h"

  -- Set the width of .cpp window to fill remaining space
  vim.cmd("vertical resize " .. (vim.o.columns - 30))

  -- Move right to input.txt
  vim.cmd "wincmd l"
  vim.cmd "vertical resize 20"

  -- Stack output.txt below input.txt
  vim.cmd "wincmd j"
  vim.cmd("resize " .. math.floor(vim.o.lines / 3))

  -- Stack expected.txt below output.txt
  vim.cmd "wincmd j"
  vim.cmd("resize " .. math.floor(vim.o.lines / 3))

  vim.cmd "wincmd h"
end

vim.api.nvim_set_keymap("n", "<leader>rs", ":lua ResizeContestLayout()<CR>", { noremap = true, silent = true })
