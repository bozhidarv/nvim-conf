MiniDeps.add {
  source = 'hrsh7th/nvim-cmp',
  depends = {
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-cmdline',

    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'folke/lazydev.nvim',
  },
}

local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}
--#endregion

--#region cmp Setup
local cmp = require 'cmp'
local custom_border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
---@type cmp.ConfigSchema
local cmp_options = {
  window = {
    completion = { -- rounded border; thin-style scrollbar
      border = custom_border,
      scrollbar = '║',
    },
    documentation = { -- no border; native-style scrollbar
      border = custom_border,
      scrollbar = '║',
      -- other options
    },
  },
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
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
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
  formatting = {
    expandable_indicator = true,
    fields = { 'kind', 'abbr', 'menu' },
    ---@param entry cmp.Entry
    ---@param vim_item vim.CompletedItem
    format = function(entry, vim_item)
      ---@type string
      local icon = ''
      local hl_group = ''
      if vim_item.kind == 'Supermaven' then
        icon = ''
        vim.api.nvim_set_hl(0, 'CmpItemKindSupermaven', { fg = '#6CC644' })
        hl_group = 'CmpItemKindSupermaven'
      else
        icon, hl_group = MiniIcons.get('lsp', vim_item.kind:lower())
      end
      -- icon, hl_group = MiniIcons.get('lsp', vim_item.kind:lower())
      vim_item.menu = '[' .. vim_item.kind .. ']'
      vim_item.menu_hl_group = hl_group
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
    { name = 'nvim_lsp_signature_help' },
    { name = 'hrsh7th/cmp-cmdline' },
    -- { name = 'supermaven' },
    { name = 'lazydev', group_index = 0 },
  },
}

cmp.setup(cmp_options)

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
  matching = { disallow_symbol_nonprefix_matching = false },
})
