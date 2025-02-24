---@type integer | nil
local notes_bufnr = nil

---@type integer | nil
local notes_winid = nil

---@type integer[]
local cursor_pos = {}

local function starts_with(str, prefix)
  return string.sub(str, 1, #prefix) == prefix
end

local function create_file_with_dirs(filepath)
  local dir = vim.fn.fnamemodify(filepath, ':h') -- Get directory path from file

  -- Create parent directories if they do not exist
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, 'p') -- "p" ensures parent directories are created
  end

  -- Create an empty file if it does not exist
  if vim.fn.filereadable(filepath) == 0 then
    local file = io.open(filepath, 'w')
    if file then
      file:close()
    end
  end
end

local function toggle_notes()
  if notes_winid and vim.api.nvim_win_is_valid(notes_winid) then
    if notes_bufnr and vim.api.nvim_buf_is_valid(notes_bufnr) then
      vim.api.nvim_buf_delete(notes_bufnr, { force = true }) -- Close window if open
    else
      vim.api.nvim_win_close(notes_winid, true) -- Close window if open
    end

    notes_winid = nil
    notes_bufnr = nil
    return
  end

  local file = vim.fn.stdpath 'data' .. '/notes/notes.md' -- Ensure correct file path
  notes_bufnr = vim.api.nvim_create_buf(false, true)

  if vim.fn.filereadable(file) == 1 then
    local lines = vim.fn.readfile(file, '', 1000)
    vim.api.nvim_buf_set_lines(notes_bufnr, 0, -1, false, lines)
  else
    vim.api.nvim_buf_set_lines(notes_bufnr, 0, -1, false, { '# Notes', '' }) -- Initialize empty file with a header
  end

  vim.api.nvim_set_option_value('filetype', 'markdown', { buf = notes_bufnr })
  vim.api.nvim_set_option_value('buftype', '', { buf = notes_bufnr })
  vim.api.nvim_set_option_value('modifiable', true, { buf = notes_bufnr })
  -- vim.api.nvim_buf_set_option(buf, 'readonly', false)

  -- Get editor dimensions
  local width = math.floor(vim.o.columns * 0.7)
  local height = math.floor(vim.o.lines * 0.7)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create the floating window
  notes_winid = vim.api.nvim_open_win(notes_bufnr, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    border = 'rounded',
  })

  if vim.fn.empty(cursor_pos) == 0 then
    vim.api.nvim_win_set_cursor(notes_winid, cursor_pos)
  end

  vim.api.nvim_create_autocmd('BufLeave', {
    desc = '',
    callback = function()
      if vim.fn.filereadable(file) then
        create_file_with_dirs(file)
      end
      cursor_pos = vim.api.nvim_win_get_cursor(notes_winid)
      local lines = vim.api.nvim_buf_get_lines(notes_bufnr, 0, -1, false)
      vim.fn.writefile(lines, file, 's')
    end,
    buffer = notes_bufnr,
  })

  -- Set keymap to close with 'q'
  vim.api.nvim_buf_set_keymap(notes_bufnr, 'n', 'q', '<cmd>ToggleNotes<CR>', { noremap = true, silent = true })

  vim.keymap.set('n', '<C-N>', function()
    local keys = vim.api.nvim_replace_termcodes('o- [ ] ', true, false, true)
    vim.api.nvim_feedkeys(keys, 'n', false)
  end, { noremap = true, silent = true, buffer = notes_bufnr })

  local new_line = ''
  vim.keymap.set('n', '<C-X>', function()
    local line = vim.api.nvim_get_current_line()
    if starts_with(vim.fn.trim(line), '- [ ]') then
      new_line = string.gsub(line, '%[ %]', '[x]', 1)
    elseif starts_with(vim.fn.trim(line), '- [x]') then
      new_line = string.gsub(line, '%[x%]', '[ ]', 1)
    else
      return
    end
    vim.api.nvim_set_current_line(new_line)
  end, { noremap = true, silent = true, buffer = notes_bufnr })
end

vim.api.nvim_create_user_command('ToggleNotes', toggle_notes, { desc = 'Toggle a floating notes.md window' })

vim.keymap.set('n', '<F1>', '<cmd>ToggleNotes<CR>', { noremap = true, silent = true, desc = 'Open notes' })
