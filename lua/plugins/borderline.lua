MiniDeps.add {
  source = 'mikesmithgh/borderline.nvim',
}

---@type BorderlineOptions
require('borderline').setup {
  border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
}
