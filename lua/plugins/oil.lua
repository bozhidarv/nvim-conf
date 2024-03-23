return {
  'stevearc/oil.nvim',
  opts = {},
  lazy = true,
  cond = false,
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      columns = {
        "icon",
        "permissions",
        -- "size",
        -- "mtime",
      }
    })
  end
}
