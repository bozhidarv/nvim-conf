return {
  settings = {
    gopls = {
      ['ui.inlayhint.hints'] = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      hoverKind = 'FullDocumentation',
    },
  },
}
