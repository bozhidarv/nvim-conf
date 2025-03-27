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

local win_opened = false

-- Function to open a file in a floating window
local function open_file_in_float(filepath)
  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true) -- false: not listed, true: scratch buffer

  -- Define floating window dimensions and position
  local width = math.floor(vim.o.columns * 0.8) -- 80% of editor width
  local height = math.floor(vim.o.lines * 0.8) -- 80% of editor height
  local row = math.floor((vim.o.lines - height) / 2) -- Center vertically
  local col = math.floor((vim.o.columns - width) / 2) -- Center horizontally

  -- Floating window configuration
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    border = 'rounded', -- Optional: adds a rounded border
  }

  -- Open the floating window with the buffer
  local _ = vim.api.nvim_open_win(buf, true, opts)

  -- Load the file into the buffer
  if filepath and vim.fn.filereadable(filepath) == 0 then
    create_file_with_dirs(filepath)
  end

  vim.api.nvim_command('edit ' .. vim.fn.fnameescape(filepath))

  -- Ensure the buffer is modifiable
  vim.api.nvim_set_option_value('filetype', 'markdown', { buf = notes_bufnr })
  vim.api.nvim_set_option_value('buftype', '', { buf = notes_bufnr })
  vim.api.nvim_set_option_value('modifiable', true, { buf = notes_bufnr })

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

vim.api.nvim_create_user_command('ToggleNotes', function(args)
  local filename = args.args
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  if win_opened then
    vim.api.nvim_win_close(vim.api.nvim_get_current_win(), false)
    win_opened = false
  end

  if bufname == filename then
    vim.api.nvim_buf_call(bufnr, function()
      vim.api.nvim_command 'write'
    end)
  else
    win_opened = true
    open_file_in_float(filename)
  end
end, { desc = 'Toggle a floating notes.md window', nargs = 1 })

local function get_local_note_name()
  ---@type string
  local str = vim.fn.getcwd():gsub(os.getenv 'HOME' .. '/', '')
  str = str:gsub('/', '.')

  return str
end

vim.keymap.set('n', '<F2>', '<cmd>ToggleNotes ' .. vim.fn.stdpath 'data' .. '/notes/notes.md' .. '<CR>', { noremap = true, silent = true, desc = 'Open notes' })
vim.keymap.set(
  'n',
  '<F1>',
  '<cmd>ToggleNotes ' .. vim.fn.stdpath 'data' .. '/notes/' .. get_local_note_name() .. '.md' .. '<CR>',
  { noremap = true, silent = true, desc = 'Open notes' }
)
