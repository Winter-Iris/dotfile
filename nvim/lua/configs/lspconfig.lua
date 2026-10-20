require("nvchad.configs.lspconfig").defaults()

local servers = {
  "taplo",          -- 对应 taplo (TOML)
  "yamlls",         -- 对应 yaml-language-server (YAML)
  "jsonls",         -- 对应 json-lsp (JSON)
  "cssls",          -- 对应 css-lsp (CSS/SCSS/Less)
  "html",           -- 对应 html-lsp (HTML)
  "gopls",          -- 对应 gopls (Go)
  "rust_analyzer",  -- 对应 rust-analyzer (Rust)
  "ruff",           -- 对应 ruff (Python Linter/Formatter)
  "pyright",        -- 对应 pyright (Python LSP)
  "clangd",         -- 对应 clangd (C/C++)
}

if vim.lsp.enable then
  vim.lsp.enable(servers)
else
  local lspconfig = require "lspconfig"
  local nvlsp = require "nvchad.configs.lspconfig"
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
    }
  end
end

-- read :h vim.lsp.config for changing options of lsp servers 
