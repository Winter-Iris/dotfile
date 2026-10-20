-- ~/.config/nvim/lua/configs/conform.lua
local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff" },
    rust = { "rustfmt" },
    go = { "gofumpt", "goimports" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    json = { "prettierd" },
    yaml = { "prettierd" },
    toml = { "taplo" },
  },

  -- -- 取消下面这行代码的注释，即可实现“保存文件时自动格式化”
  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
