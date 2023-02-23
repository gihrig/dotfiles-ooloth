local set = vim.keymap.set

return {
  --------------
  -- LSP SAGA --
  --------------
  {
    'glepnir/lspsaga.nvim',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      { 'nvim-treesitter/nvim-treesitter' }, -- please make sure you install markdown and markdown_inline parsers
    },
    event = 'BufRead',
    opts = {
      definition = { edit = '<cr>' },
      scroll_preview = { scroll_down = '<C-j>', scroll_up = '<C-k>' },
      symbol_in_winbar = { enable = false },
      ui = { border = 'rounded' },
    },
  },

  --------------------------------------
  -- 1. CUSTOMIZE LSP SERVER SETTINGS --
  --------------------------------------
  {
    'neovim/nvim-lspconfig',
    -- see: https://www.lazyvim.org/plugins/lsp#nvim-lspconfig
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        float = { border = 'rounded', source = true },
      },
      -- LSP Server Settings
      servers = {
        bashls = {},
        cssls = {},
        cssmodules_ls = {},
        dockerls = {},
        emmet_ls = {},
        eslint = {
          settings = {
            -- helpful when eslintrc is in a subfolder
            workingDirectory = { mode = 'auto' },
          },
        },
        html = {},
        jsonls = {},
        lua_ls = {},
        marksman = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                diagnosticMode = 'workspace',
                typeCheckingMode = 'off', -- using pyright for lsp but mypy for type-checking
                useLibraryCodeForTypes = true,
              },
              disableOrganizeImports = true, -- using isort for import sorting
            },
          },
        },
        -- TODO: only load if used by project
        tailwindcss = {},
        terraformls = {},
        tsserver = {},
        yamlls = {},
      },
      setup = {
        eslint = function()
          vim.cmd([[
            autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll
          ]])
        end,
      },
    },
  },

  --------------------------------------------------
  -- 3. DEFINE LINTERS & FORMATTERS USING NULL-LS --
  --------------------------------------------------
  {
    'jose-elias-alvarez/null-ls.nvim',
    opts = function() -- replace all default opts
      local nls = require('null-ls')
      return {
        -- formatters & linters mason will automatically install + set up below
        sources = {
          -- see: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#code-actions
          nls.builtins.code_actions.proselint,

          -- see: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#diagnostics
          nls.builtins.diagnostics.flake8, -- python linter
          nls.builtins.diagnostics.markdownlint, -- markdown linter
          nls.builtins.diagnostics.mypy, -- python type-checker
          nls.builtins.diagnostics.proselint, -- prose linter
          nls.builtins.diagnostics.puglint, -- pug linter
          nls.builtins.diagnostics.tsc, -- ts type-checker
          nls.builtins.diagnostics.yamllint, -- yaml linter
          nls.builtins.diagnostics.zsh, -- zsh linter

          -- see: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#formatting
          -- formatting.beautysh, -- zsh/bash/sh (reenable when settings configurable)
          nls.builtins.formatting.black, -- python
          nls.builtins.formatting.isort, -- python
          nls.builtins.formatting.prettier, -- js/ts etc
          nls.builtins.formatting.shfmt, -- bash
          nls.builtins.formatting.stylua, -- lua
        },
      }
    end,
  },

  --------------------------------------------------------------------------
  -- 4. AUTOMATICALLY INSTALL + SET UP NULL-LS SOURCES WITH MASON-NULL-LS --
  --------------------------------------------------------------------------
  {
    'jay-babu/mason-null-ls.nvim',
    -- see: https://github.com/jay-babu/mason-null-ls.nvim#primary-source-of-truth-is-null-ls
    opts = {
      ensure_installed = nil, -- defined in null-ls sources above
      automatic_installation = true,
      automatic_setup = true,
    },
  },
}
