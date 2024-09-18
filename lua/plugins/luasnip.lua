return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    -- Load snippets from custom path
    require("luasnip.loaders.from_lua").load({ paths = { "~/.config/nvim/snippets/" } })
    -- Setup LuaSnip key mappings
    local luasnip = require("luasnip")

    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "")
      end
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { silent = true })
  end,
}
