return {

  base46 = {
    theme = 'onedark', -- default theme
    integrations = { 'dap', 'trouble', 'todo' },
  },

  ui = {
    cmp = {
      icons = true,
      lspkind_text = true,
      style = 'atom_colored', -- default/flat_light/flat_dark/atom/atom_colored
    },
    tabufline = {
      enabled = false,
    },
    -- telescope = { style = 'borderless' }, -- borderless / bordered
    statusline = {
      theme = 'default', -- default/vscode/vscode_colored/minimal
      -- default/round/block/arrow separators work only for default statusline theme
      -- round and block will work for minimal theme only
      separator_style = 'default',
      order = { 'mode', 'file_info', 'git', '%=', 'lsp_msg', '%=', 'lsp', 'cwd', 'cursor' },
      modules = {
        file_info = require('options.utils').file,
      },
    },
    lsp = { signature = true },
    mason = { cmd = true, pkgs = {} },
    colorify = {
      enabled = true,
      mode = 'virtual', -- fg, bg, virtual
      virt_text = '󱓻 ',
      highlight = { hex = true, lspvars = true },
    },
  },
  nvdash = {
    load_on_startup = true,

    header = {
      '                                                     ',
      '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
      '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
      '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
      '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
      '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
      '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
      '                                                     ',
      '                                                     ',
      '                                                     ',
    },

    buttons = {
      { txt = '  Find File', keys = 'Spc Spc', cmd = 'FzfLua files' },
      { txt = '󰈚  Recent Files', keys = 'Spc ?', cmd = 'FzfLua oldfiles' },
      { txt = '󰈭  Find Word', keys = 'Spc f w', cmd = 'FzfLua grep_visual' },
      { txt = '󰊢  LazyGit', keys = 'Spc g g', cmd = 'LazyGitOpen' },
      { txt = '  Mappings', keys = 'Spc c h', cmd = 'NvCheatsheet' },
    },
  },
}
