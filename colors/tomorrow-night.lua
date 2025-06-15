-- Tomorrow Night colorscheme for Neovim with Treesitter support
-- Based on https://github.com/chriskempson/tomorrow-theme

local M = {}

-- Tomorrow Night color palette
local colors = {
  bg = '#1d1f21',
  current_line = '#282a2e',
  selection = '#373b41',
  fg = '#c5c8c6',
  comment = '#969896',
  red = '#cc6666',
  orange = '#de935f',
  yellow = '#f0c674',
  green = '#b5bd68',
  aqua = '#8abeb7',
  blue = '#81a2be',
  purple = '#b294bb',

  -- Syntax colors
  keyword = '#B294BB',
  func = '#85B7B1',
  string = '#B5BD68',
  number = '#DE935F',
  constant = '#DE935F',
  type = '#DE935F',
  tag = '#92B2CA',

  -- Additional colors for UI elements
  bg_light = '#373b41',
  bg_lighter = '#4b5263',
  fg_dark = '#969896',
  none = 'NONE',
  bg_dark = '#17181A',
  bg_highlight = '#373B41',
  bg_visual = '#373B41',
  bg_line = '#282A2E',

  fg_light = '#FFFFFF',

  -- UI colors
  border = '#1C1D1F',
  cursor = '#8ABEB7',

  -- Diagnostic colors
  error = '#CC6666',
  warning = '#F0C674',
  info = '#81A2BE',
  hint = '#63666E',

  -- Diff colors
  add = '#B5BD68',
  change = '#F0C674',
  delete = '#CC6666',
}
vim.cmd 'hi clear'
if vim.fn.exists 'syntax_on' then
  vim.cmd 'syntax reset'
end

vim.o.termguicolors = true
vim.g.colors_name = 'tomorrow-night'

-- Terminal colors
vim.g.terminal_color_0 = colors.bg
vim.g.terminal_color_1 = colors.red
vim.g.terminal_color_2 = colors.green
vim.g.terminal_color_3 = colors.yellow
vim.g.terminal_color_4 = colors.blue
vim.g.terminal_color_5 = colors.purple
vim.g.terminal_color_6 = colors.aqua
vim.g.terminal_color_7 = colors.fg
vim.g.terminal_color_8 = colors.selection
vim.g.terminal_color_9 = colors.red
vim.g.terminal_color_10 = colors.green
vim.g.terminal_color_11 = colors.yellow
vim.g.terminal_color_12 = colors.blue
vim.g.terminal_color_13 = colors.purple
vim.g.terminal_color_14 = colors.aqua
vim.g.terminal_color_15 = colors.fg

local highlights = {
  -- Editor highlights
  Normal = { fg = colors.fg, bg = colors.bg },
  NormalFloat = { fg = colors.fg, bg = colors.current_line },
  ColorColumn = { bg = colors.current_line },
  Conceal = { fg = colors.comment },
  Cursor = { fg = colors.bg, bg = colors.fg },
  CursorIM = { fg = colors.bg, bg = colors.fg },
  CursorColumn = { bg = colors.current_line },
  CursorLine = { bg = colors.current_line },
  CursorLineNr = { fg = colors.yellow, bg = colors.current_line },
  Directory = { fg = colors.blue },
  DiffAdd = { fg = colors.green, bg = colors.bg },
  DiffChange = { fg = colors.yellow, bg = colors.bg },
  DiffDelete = { fg = colors.red, bg = colors.bg },
  DiffText = { fg = colors.blue, bg = colors.bg },
  EndOfBuffer = { fg = colors.bg },
  ErrorMsg = { fg = colors.red },
  VertSplit = { fg = colors.selection },
  WinSeparator = { fg = colors.selection },
  Folded = { fg = colors.comment, bg = colors.current_line },
  FoldColumn = { fg = colors.comment, bg = colors.bg },
  SignColumn = { fg = colors.comment, bg = colors.bg },
  IncSearch = { fg = colors.bg, bg = colors.yellow },
  LineNr = { fg = colors.comment },
  MatchParen = { fg = colors.fg, bg = colors.selection },
  ModeMsg = { fg = colors.green },
  MoreMsg = { fg = colors.green },
  NonText = { fg = colors.selection },
  Pmenu = { fg = colors.fg, bg = colors.current_line },
  PmenuSel = { fg = colors.bg, bg = colors.blue },
  PmenuSbar = { bg = colors.current_line },
  PmenuThumb = { bg = colors.selection },
  Question = { fg = colors.green },
  Search = { fg = colors.bg, bg = colors.yellow },
  SpecialKey = { fg = colors.selection },
  SpellBad = { sp = colors.red, style = 'undercurl' },
  SpellCap = { sp = colors.blue, style = 'undercurl' },
  SpellLocal = { sp = colors.aqua, style = 'undercurl' },
  SpellRare = { sp = colors.purple, style = 'undercurl' },
  StatusLine = { fg = colors.fg, bg = colors.current_line },
  StatusLineNC = { fg = colors.comment, bg = colors.current_line },
  TabLine = { fg = colors.comment, bg = colors.current_line },
  TabLineFill = { bg = colors.current_line },
  TabLineSel = { fg = colors.fg, bg = colors.bg },
  Title = { fg = colors.blue },
  Visual = { bg = colors.selection },
  VisualNOS = { bg = colors.selection },
  WarningMsg = { fg = colors.yellow },
  Whitespace = { fg = colors.selection },
  WildMenu = { fg = colors.bg, bg = colors.yellow },

  -- Syntax highlighting
  Comment = { fg = colors.comment, italic = true },
  Constant = { fg = colors.orange },
  String = { fg = colors.green },
  Character = { fg = colors.green },
  Number = { fg = colors.orange },
  Boolean = { fg = colors.orange },
  Float = { fg = colors.orange },
  Identifier = { fg = colors.red },
  Function = { fg = colors.blue },
  Statement = { fg = colors.purple },
  Conditional = { fg = colors.purple },
  Repeat = { fg = colors.purple },
  Label = { fg = colors.purple },
  Operator = { fg = colors.fg },
  Keyword = { fg = colors.purple },
  Exception = { fg = colors.purple },
  PreProc = { fg = colors.yellow },
  Include = { fg = colors.blue },
  Define = { fg = colors.purple },
  Macro = { fg = colors.red },
  PreCondit = { fg = colors.yellow },
  Type = { fg = colors.yellow },
  StorageClass = { fg = colors.yellow },
  Structure = { fg = colors.yellow },
  Typedef = { fg = colors.yellow },
  Special = { fg = colors.aqua },
  SpecialChar = { fg = colors.aqua },
  Tag = { fg = colors.red },
  Delimiter = { fg = colors.fg },
  SpecialComment = { fg = colors.comment },
  Debug = { fg = colors.red },
  Underlined = { style = 'underline' },
  Error = { fg = colors.red },
  Todo = { fg = colors.yellow, bg = colors.current_line },

  -- Treesitter highlights
  ['@annotation'] = { fg = colors.yellow },
  ['@attribute'] = { fg = colors.yellow },
  ['@boolean'] = { fg = colors.orange },
  ['@character'] = { fg = colors.green },
  ['@character.special'] = { fg = colors.aqua },
  ['@comment'] = { fg = colors.comment, italic = true },
  ['@conditional'] = { fg = colors.purple },
  ['@constant'] = { fg = colors.orange },
  ['@constant.builtin'] = { fg = colors.orange },
  ['@constant.macro'] = { fg = colors.orange },
  ['@constructor'] = { fg = colors.yellow },
  ['@error'] = { fg = colors.red },
  ['@exception'] = { fg = colors.purple },
  ['@field'] = { fg = colors.red },
  ['@float'] = { fg = colors.orange },
  ['@function'] = { fg = colors.blue },
  ['@function.builtin'] = { fg = colors.blue },
  ['@function.call'] = { fg = colors.blue },
  ['@function.macro'] = { fg = colors.blue },
  ['@include'] = { fg = colors.blue },
  ['@keyword'] = { fg = colors.purple },
  ['@keyword.function'] = { fg = colors.purple },
  ['@keyword.operator'] = { fg = colors.purple },
  ['@keyword.return'] = { fg = colors.purple },
  ['@label'] = { fg = colors.purple },
  ['@method'] = { fg = colors.blue },
  ['@method.call'] = { fg = colors.blue },
  ['@namespace'] = { fg = colors.yellow },
  ['@none'] = { fg = colors.fg },
  ['@number'] = { fg = colors.orange },
  ['@operator'] = { fg = colors.fg },
  ['@parameter'] = { fg = colors.red },
  ['@parameter.reference'] = { fg = colors.red },
  ['@property'] = { fg = colors.red },
  ['@punctuation.bracket'] = { fg = colors.fg },
  ['@punctuation.delimiter'] = { fg = colors.fg },
  ['@punctuation.special'] = { fg = colors.fg },
  ['@repeat'] = { fg = colors.purple },
  ['@string'] = { fg = colors.green },
  ['@string.escape'] = { fg = colors.aqua },
  ['@string.regex'] = { fg = colors.aqua },
  ['@string.special'] = { fg = colors.aqua },
  ['@symbol'] = { fg = colors.green },
  ['@tag'] = { fg = colors.red },
  ['@tag.attribute'] = { fg = colors.yellow },
  ['@tag.delimiter'] = { fg = colors.fg },
  ['@text'] = { fg = colors.fg },
  ['@text.danger'] = { fg = colors.red },
  ['@text.emphasis'] = { italic = true },
  ['@text.literal'] = { fg = colors.green },
  ['@text.note'] = { fg = colors.blue },
  ['@text.reference'] = { fg = colors.aqua },
  ['@text.strong'] = { bold = true },
  ['@text.title'] = { fg = colors.blue, bold = true },
  ['@text.underline'] = { underline = true },
  ['@text.uri'] = { fg = colors.aqua, underline = true },
  ['@text.warning'] = { fg = colors.yellow },
  ['@type'] = { fg = colors.yellow },
  ['@type.builtin'] = { fg = colors.yellow },
  ['@type.definition'] = { fg = colors.yellow },
  ['@type.qualifier'] = { fg = colors.purple },
  ['@variable'] = { fg = colors.fg },
  ['@variable.builtin'] = { fg = colors.red },

  -- LSP highlights
  LspReferenceText = { bg = colors.selection },
  LspReferenceRead = { bg = colors.selection },
  LspReferenceWrite = { bg = colors.selection },
  DiagnosticError = { fg = colors.red },
  DiagnosticWarn = { fg = colors.yellow },
  DiagnosticInfo = { fg = colors.blue },
  DiagnosticHint = { fg = colors.aqua },
  DiagnosticUnderlineError = { sp = colors.red, style = 'undercurl' },
  DiagnosticUnderlineWarn = { sp = colors.yellow, style = 'undercurl' },
  DiagnosticUnderlineInfo = { sp = colors.blue, style = 'undercurl' },
  DiagnosticUnderlineHint = { sp = colors.aqua, style = 'undercurl' },

  -- Git highlights
  GitSignsAdd = { fg = colors.green },
  GitSignsChange = { fg = colors.yellow },
  GitSignsDelete = { fg = colors.red },

  -- Telescope highlights
  TelescopeSelection = { bg = colors.selection },
  TelescopeSelectionCaret = { fg = colors.yellow },
  TelescopeMultiSelection = { bg = colors.current_line },
  TelescopeNormal = { fg = colors.fg },
  TelescopeBorder = { fg = colors.selection },
  TelescopePromptNormal = { fg = colors.fg },
  TelescopePromptBorder = { fg = colors.selection },
  TelescopeResultsNormal = { fg = colors.fg },
  TelescopeResultsBorder = { fg = colors.selection },
  TelescopePreviewNormal = { fg = colors.fg },
  TelescopePreviewBorder = { fg = colors.selection },

  -- NvimTree highlights
  NvimTreeNormal = { fg = colors.fg, bg = colors.bg },
  NvimTreeFolderName = { fg = colors.blue },
  NvimTreeFolderIcon = { fg = colors.blue },
  NvimTreeOpenedFolderName = { fg = colors.blue, bold = true },
  NvimTreeEmptyFolderName = { fg = colors.comment },
  NvimTreeRootFolder = { fg = colors.purple },
  NvimTreeSpecialFile = { fg = colors.yellow },
  NvimTreeGitDirty = { fg = colors.yellow },
  NvimTreeGitNew = { fg = colors.green },
  NvimTreeGitDeleted = { fg = colors.red },
  NvimTreeIndentMarker = { fg = colors.selection },

  -- Which-key highlights
  WhichKey = { fg = colors.purple },
  WhichKeyGroup = { fg = colors.blue },
  WhichKeyDesc = { fg = colors.fg },
  WhichKeySeparator = { fg = colors.comment },
  WhichKeyFloat = { bg = colors.current_line },

  -- Indent-blankline highlights
  IndentBlanklineChar = { fg = colors.selection },
  IndentBlanklineContextChar = { fg = colors.comment },

  -- Mini.statusline highlights
  MiniStatuslineModeNormal = { fg = colors.bg, bg = colors.blue, bold = true },
  MiniStatuslineModeInsert = { fg = colors.bg, bg = colors.green, bold = true },
  MiniStatuslineModeVisual = { fg = colors.bg, bg = colors.purple, bold = true },
  MiniStatuslineModeReplace = { fg = colors.bg, bg = colors.red, bold = true },
  MiniStatuslineModeCommand = { fg = colors.bg, bg = colors.yellow, bold = true },
  MiniStatuslineModeOther = { fg = colors.bg, bg = colors.aqua, bold = true },
  MiniStatuslineDevinfo = { fg = colors.fg, bg = colors.selection },
  MiniStatuslineFilename = { fg = colors.fg, bg = colors.current_line },
  MiniStatuslineFileinfo = { fg = colors.comment, bg = colors.current_line },
  MiniStatuslineInactive = { fg = colors.comment, bg = colors.bg },
  ArrowStatusLine = { bg = colors.selection, fg = colors.yellow, bold = true },

  -- FzfLua
  FzfLuaNormal = { fg = colors.fg, bg = colors.bg_dark },
  FzfLuaBorder = { fg = colors.border, bg = colors.bg_dark },
  FzfLuaTitle = { fg = colors.purple, bg = colors.bg_dark, bold = true },
  FzfLuaPreviewNormal = { fg = colors.fg, bg = colors.bg },
  FzfLuaPreviewBorder = { fg = colors.border, bg = colors.bg },
  FzfLuaPreviewTitle = { fg = colors.purple, bg = colors.bg, bold = true },
  FzfLuaCursor = { fg = colors.bg, bg = colors.fg },
  FzfLuaCursorLine = { bg = colors.bg_highlight },
  FzfLuaCursorLineNr = { fg = colors.yellow, bold = true },
  FzfLuaScrollBorderEmpty = { fg = colors.bg_dark },
  FzfLuaScrollBorderFull = { fg = colors.border },
  FzfLuaScrollFloatEmpty = { bg = colors.bg_dark },
  FzfLuaScrollFloatFull = { bg = colors.border },
  FzfLuaHelpNormal = { fg = colors.fg, bg = colors.bg_dark },
  FzfLuaHelpBorder = { fg = colors.border, bg = colors.bg_dark },
  FzfLuaFzfNormal = { fg = colors.fg },
  FzfLuaFzfMatch = { fg = colors.orange, bold = true },
  FzfLuaFzfBorder = { fg = colors.border },
  FzfLuaFzfScrollbar = { fg = colors.border },
  FzfLuaFzfGutter = { bg = colors.bg },
  FzfLuaFzfHeader = { fg = colors.comment },
  FzfLuaFzfInfo = { fg = colors.info },
  FzfLuaFzfPointer = { fg = colors.purple },
  FzfLuaFzfMarker = { fg = colors.yellow },
  FzfLuaFzfSpinner = { fg = colors.purple },
  FzfLuaFzfPrompt = { fg = colors.blue },
  FzfLuaFzfQuery = { fg = colors.fg },

  -- blink.cmp
  BlinkCmpLabel = { fg = colors.fg },
  BlinkCmpLabelDeprecated = { fg = colors.comment, strikethrough = true },
  BlinkCmpLabelMatch = { fg = colors.orange, bold = true },
  BlinkCmpLabelDescription = { fg = colors.comment },
  BlinkCmpLabelDetail = { fg = colors.comment },
  BlinkCmpKind = { fg = colors.purple },
  BlinkCmpKindText = { fg = colors.fg },
  BlinkCmpKindMethod = { fg = colors.func },
  BlinkCmpKindFunction = { fg = colors.func },
  BlinkCmpKindConstructor = { fg = colors.type },
  BlinkCmpKindField = { fg = colors.fg },
  BlinkCmpKindVariable = { fg = colors.fg },
  BlinkCmpKindClass = { fg = colors.type },
  BlinkCmpKindInterface = { fg = colors.type },
  BlinkCmpKindModule = { fg = colors.purple },
  BlinkCmpKindProperty = { fg = colors.fg },
  BlinkCmpKindUnit = { fg = colors.constant },
  BlinkCmpKindValue = { fg = colors.constant },
  BlinkCmpKindEnum = { fg = colors.type },
  BlinkCmpKindKeyword = { fg = colors.keyword },
  BlinkCmpKindSnippet = { fg = colors.green },
  BlinkCmpKindColor = { fg = colors.orange },
  BlinkCmpKindFile = { fg = colors.blue },
  BlinkCmpKindReference = { fg = colors.blue },
  BlinkCmpKindFolder = { fg = colors.blue },
  BlinkCmpKindEnumMember = { fg = colors.constant },
  BlinkCmpKindConstant = { fg = colors.constant },
  BlinkCmpKindStruct = { fg = colors.type },
  BlinkCmpKindEvent = { fg = colors.purple },
  BlinkCmpKindOperator = { fg = colors.fg },
  BlinkCmpKindTypeParameter = { fg = colors.type },
  BlinkCmpDoc = { fg = colors.fg, bg = colors.bg_dark },
  BlinkCmpDocBorder = { fg = colors.border, bg = colors.bg_dark },
  BlinkCmpDocCursorLine = { bg = colors.bg_highlight },
  BlinkCmpSignatureHelp = { fg = colors.fg, bg = colors.bg_dark },
  BlinkCmpSignatureHelpBorder = { fg = colors.border, bg = colors.bg_dark },
  BlinkCmpSignatureHelpActiveParameter = { fg = colors.orange, bold = true },
  BlinkCmpItemIdx = { fg = colors.comment },
  BlinkCmpSource = { fg = colors.comment },
  BlinkCmpGhostText = { fg = colors.comment },
  BlinkCmpMenu = { fg = colors.fg, bg = colors.bg_dark },
  BlinkCmpMenuBorder = { fg = colors.border, bg = colors.bg_dark },
  BlinkCmpMenuSelection = { bg = colors.bg_highlight },
  BlinkCmpScrollBar = { bg = colors.bg_dark },
  BlinkCmpScrollBarThumb = { bg = colors.bg_highlight },

  -- mini.icons
  MiniIconsAzure = { fg = colors.blue },
  MiniIconsBlue = { fg = colors.blue },
  MiniIconsCyan = { fg = colors.aqua },
  MiniIconsGreen = { fg = colors.green },
  MiniIconsGrey = { fg = colors.comment },
  MiniIconsOrange = { fg = colors.orange },
  MiniIconsPurple = { fg = colors.purple },
  MiniIconsRed = { fg = colors.red },
  MiniIconsYellow = { fg = colors.yellow },
}

-- Apply highlights
for group, settings in pairs(highlights) do
  local hl = {}
  if settings.fg then
    hl.fg = settings.fg
  end
  if settings.bg then
    hl.bg = settings.bg
  end
  if settings.sp then
    hl.sp = settings.sp
  end
  if settings.style then
    if settings.style == 'italic' then
      hl.italic = true
    elseif settings.style == 'bold' then
      hl.bold = true
    elseif settings.style == 'underline' then
      hl.underline = true
    elseif settings.style == 'undercurl' then
      hl.undercurl = true
    end
  end
  if settings.italic then
    hl.italic = true
  end
  if settings.bold then
    hl.bold = true
  end
  if settings.underline then
    hl.underline = true
  end
  if settings.undercurl then
    hl.undercurl = true
  end

  vim.api.nvim_set_hl(0, group, hl)
end

return M
