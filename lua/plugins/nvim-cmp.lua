return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',

    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',

    -- Adds a number of user-friendly snippets
    'rafamadriz/friendly-snippets',
  },
  config = function()
    --#region LuaSnip Setup
    local luasnip = require 'luasnip'
    require('luasnip.loaders.from_vscode').lazy_load()
    luasnip.config.setup {}
    --#endregion

    --#region cmp icons
    local cmp_kinds = {
      Text = ' ',
      Method = ' ',
      Function = '󰊕 ',
      Keyword = ' ',
      Variable = ' ',
      Property = ' ',
      Class = ' ',
      Interface = ' ',
      Module = ' ',
      Unit = ' ',
      Enum = ' ',
      Snippet = ' ',
      Field = ' ',
      File = ' ',
      Folder = ' ',
    }
    --#endregion

    --#region cmp Setup
    local cmp = require 'cmp'
    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<C-j>'] = cmp.mapping(function(_)
          vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n',
            true)
        end),
      },
      formatting = {
        expandable_indicator = false,
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          vim_item.menu = '[' .. vim_item.kind .. ']'
          vim_item.kind = (cmp_kinds[vim_item.kind] or '')
          local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
          if icon then
            vim_item.kind = icon
            vim_item.kind_hl_group = hl_group
            return vim_item
          end
          return vim_item
        end,
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'vim-dadbod-completion' },
      },
    }
    --#endregion
  end,
}
