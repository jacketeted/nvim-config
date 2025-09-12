return {
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require("lspconfig")
    lspconfig.lua_ls.setup({})
    lspconfig.ts_ls.setup({})
    lspconfig.bashls.setup({})
  end,
}
