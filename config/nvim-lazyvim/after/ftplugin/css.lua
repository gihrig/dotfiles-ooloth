-- install everything we need (see: https://mason-registry.dev/registry/list)
require('mason-tool-installer').setup({ ensure_installed = { 'cssls' } })
vim.api.nvim_command('MasonToolsInstall')

-- enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#cssls
require('lspconfig').cssls.setup({
  capabilities = capabilities,
})

-- formatting (see: https://github.com/stevearc/conform.nvim#setup)
require('conform').setup({
  formatters_by_ft = {
    css = { 'prettier' },
  },
})

--  TODO: treesitter
--  TODO: linting?
