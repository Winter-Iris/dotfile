-- ~/.config/nvim/lua/plugins/init.lua
return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      return require("configs.cmp").setup(opts)
    end,
  },

  -- 1. 代码格式化插件 (默认只配了 lua，后期可在 lua/configs/conform.lua 中扩展)
  {
    "stevearc/conform.nvim",
    -- event = "BufWritePre", -- 取消注释即可开启“保存时自动格式化”
    opts = require "configs.conform",
  },

  -- 2. 覆盖默认 lspconfig，加载你自己的 lua/configs/lspconfig.lua
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- 3. 覆盖默认 Treesitter，仅声明你需要高亮的语言
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "json", "yaml", "toml",
        "c", "cpp", "rust", "go", "python",
      },
    },
  },

  {
    "nanotee/sqls.nvim",
    lazy = false,
    ft = { "sql" },
  },

}
