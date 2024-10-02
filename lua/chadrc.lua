local sep_icons = {
  default = { left = '', right = '' },
  round = { left = '', right = '' },
  block = { left = '█', right = '█' },
  arrow = { left = '', right = '' },
}
local separators = sep_icons['default']

local sep_l = separators['left']
local sep_r = separators['right']

local file_txt = function()
  local icon = '󰈚'
  local sbufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
  local path = vim.api.nvim_buf_get_name(sbufnr)
  local name = (path == '' and 'Empty') or path:match '([^/\\]+)[/\\]*$'
  if name ~= 'Empty' then
    if vim.api.nvim_get_option_value('modified', { buf = sbufnr }) then
      name = name .. ' '
    end
    local devicons_present, devicons = pcall(require, 'nvim-web-devicons')

    if devicons_present then
      local ft_icon = devicons.get_icon(name)
      icon = (ft_icon ~= nil and ft_icon) or icon
    end
  end

  return { icon, name }
end

local file = function()
  local x = file_txt()
  local name = ' ' .. x[2] .. ' '
  return '%#St_file# ' .. x[1] .. name .. '%#St_file_sep#' .. sep_r
end

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
        abc = function()
          return 'hi'
        end,

        xyz = 'hi',
        file_info = file,
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
