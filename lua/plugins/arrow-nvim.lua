MiniDeps.add {
  source = 'otavioschwanck/arrow.nvim',
}

require('arrow').setup {
  show_icons = true,
  leader_key = "'", -- Recommended to be a single key
  buffer_leader_key = 'm', -- Per Buffer Mappings
  mappings = {
    edit = 'e',
    delete_mode = 'd',
    clear_all_items = 'C',
    toggle = 'a', -- used as save if separate_save_and_remove is true
    open_vertical = 'v',
    open_horizontal = '-',
    quit = 'q',
    remove = 'x', -- only used if separate_save_and_remove is true
    next_item = ']',
    prev_item = '[',
  },
}

---@class command_args
---@field name string Command name
---@field args string The args passed to the command, if any
---@field fargs table The args split by unescaped whitespace (when more than one argument is allowed), if any <f-args>
---@field nargs string Number of arguments `:command-nargs`
---@field bang boolean "true" if the command was executed with a ! modifier <bang>
---@field line1 number The starting line of the command range
---@field line2 number The final line of the command range
---@field range number The number of items in the command range: 0, 1, or 2 <range>
---@field count number Any count supplied <count>
---@field reg string The optional register, if specified <reg>
---@field mods string Command modifiers, if any <mods>
---@field smods table Command modifiers in a structured format. Has the same structure as the "mods" key of

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    --@param args command_args
    vim.api.nvim_create_user_command('ArrowAddAngularComponent', function(_)
      local ft_endings = { 'ts', 'html', 'scss' }
      local persist_api = require 'arrow.persist'

      local file_name = vim.fn.expand '%:t'
      if file_name:match 'component' == nil then
        vim.print('You are not in an Angular component')
        return
      end
      local full_filename = vim.fn.expand '%'
      local curr_filename = ''
      local curr_split = {}
      for i = 1, #ft_endings do
        ---@type table
        curr_split = vim.fn.split(full_filename, '\\.', true)
        curr_split[#curr_split] = ft_endings[i]
        curr_filename = vim.fn.join(curr_split, '.')
        if persist_api.is_saved(curr_filename) then
          persist_api.remove(curr_filename)
        end
        persist_api.toggle(curr_filename)
      end
    end, {})
  end,
  group = vim.api.nvim_create_augroup('ArrowAddAngularComponent', { clear = true }),
  pattern = { '*.ts', '*.html', '.scss' },
})
