require "nvchad.autocmds"

-- Dynamic terminal padding
local autocmd = vim.api.nvim_create_autocmd

autocmd("VimEnter", {
  command = ":silent !kitty @ set-spacing padding=0 margin=0",
})

autocmd("VimLeavePre", {
  command = ":silent !kitty @ set-spacing padding=20 margin=10",
})

-- Show Nvdash when all buffers are closed
autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
      vim.cmd "Nvdash"
    end
  end,
})

--clang formatter along with cursor pos
autocmd("BufWritePre", {
  pattern = "*.cpp",

  callback = function()
    -- Save cursor position
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local view = vim.fn.winsaveview()

    -- Format the file
    vim.cmd "silent! %!clang-format"

    -- Restore cursor position and view
    vim.fn.winrestview(view)
  end,
})
