local M = {}

M.firstToUpper = function(str)
  return (str:gsub('^%l', string.upper))
end

M.checkTransperancy = function()
  local isTrans = os.getenv 'TRANSPARENT_BACKGROUND'
  -- vim.print(isTrans)
  if isTrans == nil then
    return false
  end
  if isTrans == 'true' then
    return true
  end
  return false
end

M.colorscheme = 'nordic'

M.jumpWithVirtLineDiagnostics = function(jumpCount)
  pcall(vim.api.nvim_del_augroup_by_name, 'jumpWithVirtLineDiags') -- prevent autocmd for repeated jumps

  vim.diagnostic.jump { count = jumpCount }

  vim.diagnostic.config {
    virtual_text = false,
    virtual_lines = { current_line = true },
  }

  vim.defer_fn(function() -- deferred to not trigger by jump itself
    vim.api.nvim_create_autocmd('CursorMoved', {
      desc = 'User(once): Reset diagnostics virtual lines',
      once = true,
      group = vim.api.nvim_create_augroup('jumpWithVirtLineDiags', {}),
      callback = function()
        vim.diagnostic.config { virtual_lines = false, virtual_text = true }
      end,
    })
  end, 1)
end

local function run_command_internal(cmd)
  local co = assert(coroutine.running())

  local stdout = {}
  local stderr = {}
  local exit_code = nil

  local jobid = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      data = table.concat(data, '\n')
      if #data > 0 then
        stdout[#stdout + 1] = data
      end
    end,
    on_stderr = function(_, data, _)
      stderr[#stderr + 1] = table.concat(data, '\n')
    end,
    on_exit = function(_, code, _)
      exit_code = code
      coroutine.resume(co)
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })

  if jobid <= 0 then
    vim.notify(('unable to run cmd: %s'):format(cmd), vim.log.levels.WARN)
    return nil
  end

  coroutine.yield()

  if exit_code ~= 0 then
    vim.notify(('cmd failed with code %d: %s\n%s'):format(exit_code, cmd, table.concat(stderr, '')), vim.log.levels.WARN)
    return nil
  end

  if next(stdout) == nil then
    return nil
  end
  return stdout and stdout or nil
end

function M.run_command(cmd)
  coroutine.resume(coroutine.create(function()
    local status, stdout = pcall(function()
      return run_command_internal(cmd)
    end)
    if not status then
      return nil
    end
    return stdout
  end))
end

function M.search_ancestors(startpath, func)
  vim.validate('func', func, 'function')
  if func(startpath) then
    return startpath
  end
  local guard = 100
  for path in vim.fs.parents(startpath) do
    -- Prevent infinite recursion if our algorithm breaks
    guard = guard - 1
    if guard == 0 then
      return
    end

    if func(path) then
      return path
    end
  end
end

local function escape_wildcards(path)
  return path:gsub('([%[%]%?%*])', '\\%1')
end

function M.root_pattern(...)
  local patterns = vim.iter({...}):flatten(math.huge):totable()
  return function(startpath)
    startpath = vim.fn.substitute(startpath, 'zipfile://\\(.\\{-}\\)::[^\\\\].*$', '\\1', '')
    startpath  = vim.fn.substitute(startpath, 'tarfile:\\(.\\{-}\\)::.*$', '\\1', '')
    for _, pattern in ipairs(patterns) do
      local match = M.search_ancestors(startpath, function(path)
        for _, p in ipairs(vim.fn.glob(table.concat({ escape_wildcards(path), pattern }, '/'), true, true)) do
          if vim.uv.fs_stat(p) then
            return path
          end
        end
      end)

      if match ~= nil then
        return match
      end
    end
  end
end

return M
