MiniDeps.add {
  source = 'L3MON4D3/LuaSnip',
  checkout = 'v2.*',
}

MiniDeps.add {
  source = 'saghen/blink.cmp',
  depends = {
    'rafamadriz/friendly-snippets',
    'folke/lazydev.nvim',
  },
  hooks = {
    post_checkout = function() end,
  },
}

require('blink.cmp').setup {
  sources = {
    -- add lazydev to your completion providers
    default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
    providers = {
      -- dont show LuaLS require statements when lazydev has items
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        fallbacks = { 'lsp' },
      },
    },
  },
  completion = {
    menu = {
      enabled = true,
      min_width = 15,
      max_height = 10,
      border = 'padded',
      winblend = 0,
      winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
      -- Keep the cursor X lines away from the top/bottom of the window
      scrolloff = 2,
      -- Note that the gutter will be disabled when border ~= 'none'
      scrollbar = true,
      -- Which directions to show the window,
      -- falling back to the next direction when there's not enough space
      direction_priority = { 's', 'n' },

      -- Whether to automatically show the window when new completion items are available
      auto_show = true,

      -- Screen coordinates of the command line
      cmdline_position = function()
        if vim.g.ui_cmdline_pos ~= nil then
          local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
          return { pos[1] - 1, pos[2] }
        end
        local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
        return { vim.o.lines - height, 0 }
      end,

      -- Controls how the completion items are rendered on the popup window
      draw = {
        -- Aligns the keyword you've typed to a component in the menu
        align_to_component = 'label', -- or 'none' to disable
        -- Left and right padding, optionally { left, right } for different padding on each side
        padding = 1,
        -- Gap between columns
        gap = 1,
        -- Use treesitter to highlight the label text of completions from these sources
        treesitter = {},
        -- Recommended to enable it just for the LSP source
        -- treesitter = { 'lsp' }

        -- Components to render, grouped by column
        columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
        -- for a setup similar to nvim-cmp: https://github.com/Saghen/blink.cmp/pull/245#issuecomment-2463659508
        -- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },

        -- Definitions for possible components to render. Each component defines:
        --   ellipsis: whether to add an ellipsis when truncating the text
        --   width: control the min, max and fill behavior of the component
        --   text function: will be called for each item
        --   highlight function: will be called only when the line appears on screen
        components = {
          kind_icon = {
            ellipsis = false,
            text = function(ctx)
              return ctx.kind_icon .. ctx.icon_gap
            end,
            highlight = function(ctx)
              return require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or ('BlinkCmpKind' .. ctx.kind)
            end,
          },

          kind = {
            ellipsis = false,
            width = { fill = true },
            text = function(ctx)
              return ctx.kind
            end,
            highlight = function(ctx)
              return require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or ('BlinkCmpKind' .. ctx.kind)
            end,
          },

          label = {
            width = { fill = true, max = 60 },
            text = function(ctx)
              return ctx.label .. ctx.label_detail
            end,
            highlight = function(ctx)
              -- label and label details
              local highlights = {
                { 0, #ctx.label, group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel' },
              }
              if ctx.label_detail then
                table.insert(highlights, { #ctx.label, #ctx.label + #ctx.label_detail, group = 'BlinkCmpLabelDetail' })
              end

              -- characters matched on the label by the fuzzy matcher
              for _, idx in ipairs(ctx.label_matched_indices) do
                table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
              end

              return highlights
            end,
          },

          label_description = {
            width = { max = 30 },
            text = function(ctx)
              return ctx.label_description
            end,
            highlight = 'BlinkCmpLabelDescription',
          },

          source_name = {
            width = { max = 30 },
            text = function(ctx)
              return ctx.source_name
            end,
            highlight = 'BlinkCmpSource',
          },
        },
      },
    },
    documentation = {
      -- Controls whether the documentation window will automatically show when selecting a completion item
      auto_show = true,
      -- Delay before showing the documentation window
      auto_show_delay_ms = 500,
      -- Delay before updating the documentation window when selecting a new item,
      -- while an existing item is still visible
      update_delay_ms = 50,
      -- Whether to use treesitter highlighting, disable if you run into performance issues
      treesitter_highlighting = true,
      window = {
        min_width = 10,
        max_width = 60,
        max_height = 20,
        border = 'padded',
        winblend = 0,
        winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
        -- Note that the gutter will be disabled when border ~= 'none'
        scrollbar = true,
        -- Which directions to show the documentation window,
        -- for each of the possible menu window directions,
        -- falling back to the next direction when there's not enough space
        direction_priority = {
          menu_north = { 'e', 'w', 'n', 's' },
          menu_south = { 'e', 'w', 's', 'n' },
        },
      },
    },
    ghost_text = {
      enabled = true,
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
        vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n', true)
      end,
    },
  },
  appearance = {
    highlight_ns = vim.api.nvim_create_namespace 'blink_cmp',
    -- Sets the fallback highlight groups to nvim-cmp's highlight groups
    -- Useful for when your theme doesn't support blink.cmp
    -- Will be removed in a future release
    use_nvim_cmp_as_default = true,
    -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
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
