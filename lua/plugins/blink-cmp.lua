local function build_jsregexp(params)
  vim.notify('Building jsregexp', vim.log.levels.INFO)
  local obj = vim.system({ 'make', 'install_jsregexp' }, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify('Building jsregexp done', vim.log.levels.INFO)
  else
    vim.notify('Building jsregexp failed', vim.log.levels.ERROR)
  end
end

MiniDeps.add {
  source = 'L3MON4D3/LuaSnip',
  checkout = 'v2.3.0',
  hooks = {
    post_checkout = build_jsregexp,
  },
}

local function build_blink(params)
  vim.notify('Building blink.cmp', vim.log.levels.INFO)
  local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify('Building blink.cmp done', vim.log.levels.INFO)
  else
    vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
  end
end

MiniDeps.add {
  source = 'saghen/blink.cmp',
  depends = {
    'rafamadriz/friendly-snippets',
    'folke/lazydev.nvim',
  },
  hooks = {
    post_install = build_blink,
    post_checkout = build_blink,
  },
}

require('blink.cmp').setup {
  snippets = {
    expand = function(snippet)
      require('luasnip').lsp_expand(snippet)
    end,
    active = function(filter)
      if filter and filter.direction then
        return require('luasnip').jumpable(filter.direction)
      end
      return require('luasnip').in_snippet()
    end,
    jump = function(direction)
      require('luasnip').jump(direction)
    end,
  },
  sources = {
    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- make lazydev completions top priority (see `:h blink.cmp`)
        score_offset = 100,
      },
    },
  },
  -- snippets = { preset = 'default' | 'luasnip' },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
      update_delay_ms = 50,
      treesitter_highlighting = true,
      window = {
        min_width = 10,
        max_width = 60,
        max_height = 20,
        border = 'padded',
        winblend = 0,
        winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
        scrollbar = true,
        direction_priority = {
          menu_north = { 'e', 'w', 'n', 's' },
          menu_south = { 'e', 'w', 's', 'n' },
        },
      },
    },
  },
  keymap = {
    preset = 'default',
    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },

    ['<C-l>'] = { 'snippet_forward', 'fallback' },
    ['<C-h>'] = { 'snippet_backward', 'fallback' },
    ['<C-j>'] = {
      function(_)
        vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n',
          true)
      end,
    },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono',
    kind_icons = {
      Method = MiniIcons.get('lsp', 'method'),
      Function = MiniIcons.get('lsp', 'function'),
      Constructor = MiniIcons.get('lsp', 'constructor'),
      Field = MiniIcons.get('lsp', 'field'),
      Variable = MiniIcons.get('lsp', 'variable'),
      Property = MiniIcons.get('lsp', 'property'),
      Class = MiniIcons.get('lsp', 'class'),
      Interface = MiniIcons.get('lsp', 'interface'),
      Struct = MiniIcons.get('lsp', 'struct'),
      Module = MiniIcons.get('lsp', 'module'),
      Unit = MiniIcons.get('lsp', 'unit'),
      Value = MiniIcons.get('lsp', 'value'),
      Enum = MiniIcons.get('lsp', 'enum'),
      EnumMember = MiniIcons.get('lsp', 'enummember'),
      Keyword = MiniIcons.get('lsp', 'keyword'),
      Constant = MiniIcons.get('lsp', 'constant'),
      Snippet = MiniIcons.get('lsp', 'snippet'),
      Color = MiniIcons.get('lsp', 'color'),
      File = MiniIcons.get('lsp', 'file'),
      Reference = MiniIcons.get('lsp', 'reference'),
      Folder = MiniIcons.get('lsp', 'folder'),
      Event = MiniIcons.get('lsp', 'event'),
      Operator = MiniIcons.get('lsp', 'operator'),
      TypeParameter = MiniIcons.get('lsp', 'typeparameter'),
    },
  },
}
