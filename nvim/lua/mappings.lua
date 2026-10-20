require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- 用 <leader> + Enter 打开/关闭带圆角边框的浮动终端
map({ "n", "t" }, "<leader><CR>", function()
  require("nvchad.term").toggle {
    pos = "float",
    id = "floatTerm",
    float_opts = {
      border = "rounded",  -- 圆角边框
      width = 0.8,         -- 宽度占屏幕 80%
      height = 0.6,        -- 高度占屏幕 60%
      row = 0.2,           -- 垂直居中偏移
      col = 0.1,           -- 水平居中偏移
    },
  }
end, { desc = "Toggle floating terminal" })

-- nvui.code_runner
map("n", "<leader>rr", function()
  local file = vim.fn.expand("%")        -- 当前文件相对路径
  local ft = vim.bo.filetype             -- 文件类型
  local name = vim.fn.expand("%:t:r")    -- 不带扩展名的文件名，如 main

  -- 解释型语言：直接运行，无需输出目录
  -- 编译型语言：输出到 bin/，可执行文件与源文件同名
  local ft_cmds = {
    -- 解释型
    python     = "python3 " .. file,
    javascript = "node " .. file,
    typescript = "npx ts-node " .. file,
    lua        = "lua " .. file,
    sh         = "bash " .. file,
    go         = "go run " .. file,
    java       = "java " .. file,

    -- 编译型：输出到 bin/，文件名与源文件一致
    c   = "mkdir -p bin && gcc '" .. file .. "' -o bin/" .. name .. " && ./bin/" .. name,
    cpp = "mkdir -p bin && g++ '" .. file .. "' -o bin/" .. name .. " && ./bin/" .. name,
    rust = "mkdir -p bin && rustc '" .. file .. "' -o bin/" .. name .. " && ./bin/" .. name,
  }

  local cmd = ft_cmds[ft]

  if not cmd then
    vim.notify("Unsupported filetype: " .. ft, vim.log.levels.WARN)
    return
  end

  require("nvchad.term").toggle {
    id = "code_runner",
    pos = "float",
    cmd = function() return cmd end,
    clear_cmd = true,
    float_opts = { border = "rounded" },
  }
end, { desc = "Run current file" })
