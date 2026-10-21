local M = {}

function M.setup(opts)
  local cmp = require "cmp"
  local compare = require "cmp.config.compare"

  opts.sorting = vim.tbl_deep_extend("force", opts.sorting or {}, {
    comparators = {
      compare.offset,
      compare.exact,
      compare.recently_used,
      compare.score,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  })

  -- Keep database metadata ahead of words copied from the current buffer.
  cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
    sources = cmp.config.sources({
      { name = "vim-dadbod-completion" },
      { name = "luasnip" },
    }, {
      { name = "buffer", keyword_length = 3 },
    }),
  })

  return opts
end

return M
