require("nvchad.configs.lspconfig").defaults()
require("lspconfig").clangd.setup{}
local servers = { "html", "cssls" , "clangd", "clangd-format", "basedpyright"}
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
