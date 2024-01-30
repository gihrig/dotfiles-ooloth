-- install everything we need (see: https://mason-registry.dev/registry/list)
require('mason-tool-installer').setup({ ensure_installed = { 'jsonls' } })
vim.api.nvim_command('MasonToolsInstall')

-- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jsonls
require('lspconfig').jsonls.setup({
  settings = {
    json = {
      -- see: https://github.com/b0o/SchemaStore.nvim?tab=readme-ov-file#usage
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

-- formatting (see: https://github.com/stevearc/conform.nvim#setup)
require('conform').setup({
  formatters_by_ft = {
    json = { 'prettier' },
  },
})

--  TODO: treesitter
--  TODO: linting
--  TODO: dap?
