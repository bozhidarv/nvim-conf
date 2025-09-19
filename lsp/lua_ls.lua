return {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {
          'require',
        },
      },
      telemetry = {
        checkThirdParty = false,
        enable = false,
      },
      hint = { enable = true },
    },
  },
}
