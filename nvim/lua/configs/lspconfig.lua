require("nvchad.configs.lspconfig").defaults()
require("lspconfig").clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
local servers = { "html", "cssls", "clangd", "basedpyright" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
vim.lsp.config.clangd = {
  cmd = {
    -- "--clang-tidy",
    "--header-insertion=never",
    "--function-arg-placeholders=false",
  },
}
