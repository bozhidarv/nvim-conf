local add = MiniDeps.add

add {
  source = 'kevinhwang91/nvim-ufo',
  depends = {
    'kevinhwang91/promise-async',
  },
}

require('ufo').setup {
  preview = {
    mappings = {
      scrollB = '<C-b>',
      scrollF = '<C-f>',
      scrollU = '<C-u>',
      scrollD = '<C-d>',
    },
  },
  provider_selector = function(bufnr, filetype, buftype)
    return { 'treesitter', 'indent' }
  end,
}
