return {
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'folke/lazydev.nvim',
      -- 'github/copilot.vim',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
      {
        'supermaven-inc/supermaven-nvim',
        branch = 'rust-binary',
        config = function()
          require('supermaven-nvim').setup {
            keymaps = {
              accept_suggestion = '<C-j>',
              clear_suggestion = '<C-]>',
              accept_word = '<C-k>',
            },
            log_level = 'off',
          }
        end,
      },
    },
    config = function()
      --#region LuaSnip Setup
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()
      luasnip.config.setup {}
      --#endregion

      --#region cmp Setup
      local cmp = require 'cmp'
      local cmp_options = {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-y>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          },
          ['<C-e>'] = cmp.mapping.close(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          -- ['<C-j>'] = cmp.mapping(function(_)
          --   vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)),
          --     'n', true)
          -- end),
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'vim-dadbod-completion' },
          -- { name = 'supermaven' },
          { name = 'lazydev',              group_index = 0 },
        },
      }

      cmp_options = vim.tbl_deep_extend('force', cmp_options, require 'nvchad.cmp')

      cmp.setup(cmp_options)

      --#endregion
    end,
  },
}
