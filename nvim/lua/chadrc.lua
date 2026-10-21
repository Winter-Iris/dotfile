-- NvChad v3 / Base46 - Sakura Pink
-- 基于 Catppuccin，保留原生语法高亮映射
-- 主要修改 UI 强调色、蓝色语法强调色和深紫背景

---@type ChadrcConfig
local M = {}

local c = {
  -- 樱花粉主色
  pink = "#ffb7c5",
  pink_light = "#ffc5d4",
  pink_strong = "#ff91b6",

  -- 辅助色
  purple = "#d8b4f8",
  lavender = "#f5c2e7",
  cyan = "#b8f2e6",
  red = "#ff85a2",
  green = "#a6e3a1",
  yellow = "#f9e2af",
  orange = "#ffc3a6",

  -- 文字与背景
  white = "#eedcff",
  black = "#1e1a29",
  darker_black = "#18141f",
  black2 = "#262137",
  one_bg = "#30283f",
  one_bg2 = "#362d48",
  one_bg3 = "#403454",
  line = "#3a3052",
}

M.base46 = {
  theme = "catppuccin",
  transparency = true,

  changed_themes = {
    all = {},
    catppuccin = {

      -- 界面配色
      base_30 = {
        darker_black = c.darker_black,
        black = c.black,
        black2 = c.black2,
        one_bg = c.one_bg,
        one_bg2 = c.one_bg2,
        one_bg3 = c.one_bg3,
        line = c.line,
        statusline_bg = "#211b2b",
        lightbg = c.one_bg,

        white = c.white,
        grey = "#665878",
        grey_fg = "#8f809e",
        grey_fg2 = "#a191af",
        light_grey = "#b8aac5",

        -- 主要强调色：蓝色 -> 樱花粉
        pink = c.pink,
        baby_pink = c.pink_light,
        blue = c.pink,
        nord_blue = c.pink_light,

        -- 菜单、文件树
        pmenu_bg = c.pink,
        folder_bg = c.pink,

        -- 保留其他颜色的语义
        purple = c.purple,
        dark_purple = "#ba95dc",
        lavender = c.lavender,

        cyan = c.cyan,
        teal = c.cyan,

        red = c.red,
        green = c.green,
        vibrant_green = "#b7f3b0",

        yellow = c.yellow,
        sun = "#ffe6b6",
        orange = c.orange,
      },

      -- 保留 Catppuccin 原本的 Base16 语法映射
      -- 只将色值替换为 Sakura 主题的对应颜色
      base_16 = {
        -- 背景色
        base00 = c.black,
        base01 = c.black2,
        base02 = c.one_bg,
        base03 = c.line,

        -- 前景文字
        base04 = "#8f809e",
        base05 = c.white,
        base06 = "#f5e9ff",
        base07 = "#fff2f7",

        -- 原有语法颜色分工不变
        base08 = c.red,
        base09 = c.orange,
        base0A = c.yellow,
        base0B = c.green,
        base0C = c.cyan,

        -- 原来的蓝色强调位替换成樱花粉
        base0D = c.pink,

        -- 其他语法颜色仍保持原色系
        base0E = c.purple,
        base0F = c.red,
      },
    },
  },

  -- 只修改界面高亮，不覆盖任何语法高亮组
  hl_override = {
    LineNr = {
      fg = "#5a4a78",
    },

    CursorLineNr = {
      fg = c.pink,
      bold = true,
    },

    Visual = {
      bg = "#49334f",
    },

    Search = {
      fg = c.darker_black,
      bg = c.pink,
    },

    IncSearch = {
      fg = c.darker_black,
      bg = c.pink_strong,
    },

    -- 浮动窗口边框
    FloatBorder = {
      fg = c.pink,
    },

    WinSeparator = {
      fg = c.line,
    },

    -- 补全菜单
    PmenuSel = {
      fg = c.darker_black,
      bg = c.pink,
      bold = true,
    },

    -- Telescope 樱花粉边框
    TelescopeBorder = {
      fg = c.pink,
    },

    TelescopePromptBorder = {
      fg = c.pink,
    },

    TelescopeResultsBorder = {
      fg = c.pink,
    },

    TelescopePreviewBorder = {
      fg = c.purple,
    },

    TelescopePromptPrefix = {
      fg = c.pink,
    },

    TelescopePromptTitle = {
      fg = c.darker_black,
      bg = c.pink,
    },

    TelescopePreviewTitle = {
      fg = c.darker_black,
      bg = c.purple,
    },

    TelescopeResultsTitle = {
      fg = c.darker_black,
      bg = c.pink,
    },

    TelescopeSelection = {
      fg = c.white,
      bg = c.line,
    },

    TelescopeMatching = {
      fg = c.pink,
      bold = true,
    },
  },
}

-- Notification colors belong to the theme, including after Base46 reloads.
M.base46.hl_add = M.base46.hl_add or {}
local notification_hl = M.base46.hl_add
notification_hl.SnacksNotifierHistory = { fg = c.white, bg = c.darker_black }
notification_hl.SnacksNotifierHistoryTitle = { fg = c.pink, bold = true }
notification_hl.SnacksNotifierHistoryDateTime = { fg = c.purple }
notification_hl.SnacksNotifierMinimal = { fg = c.white, bg = c.darker_black }
for level, color in pairs({ Info = c.pink, Warn = c.yellow, Error = c.red, Debug = c.purple, Trace = c.cyan }) do
  notification_hl["SnacksNotifier" .. level] = { fg = c.white, bg = c.darker_black }
  notification_hl["SnacksNotifierBorder" .. level] = { fg = c.pink, bg = c.darker_black }
  notification_hl["SnacksNotifierTitle" .. level] = { fg = color, bg = c.darker_black, bold = true }
  notification_hl["SnacksNotifierIcon" .. level] = { fg = color, bg = c.darker_black }
  notification_hl["SnacksNotifierFooter" .. level] = { fg = color, bg = c.darker_black }
end
for _, group in ipairs({ "NoiceCmdlinePopup", "NoicePopup", "NoiceMini", "NoiceSplit", "NoicePopupmenu" }) do
  notification_hl[group] = { fg = c.white, bg = c.darker_black }
end
for _, group in ipairs({ "NoiceCmdlinePopupBorder", "NoicePopupBorder", "NoiceSplitBorder", "NoicePopupmenuBorder" }) do
  notification_hl[group] = { fg = c.pink, bg = c.darker_black }
end
notification_hl.NoiceCmdlineIcon = { fg = c.pink }
notification_hl.NoiceCmdlinePopupTitle = { fg = c.pink, bold = true }
notification_hl.NoicePopupmenuSelected = { fg = c.darker_black, bg = c.pink }

-- Telescope
M.ui = {
  telescope = {
    style = "bordered",
  },
}

-- 终端浮窗：70% x 40%，圆角
M.term = {
  float = {
    relative = "editor",
    row = 0.3,
    col = 0.15,
    width = 0.7,
    height = 0.4,
    border = "rounded",
  },
}

-- SQL query buffers can have their ftplugin options reset during loading.
-- Check again after filetype handlers finish, and when returning to a buffer.
local sql_filetypes = { sql = true, mysql = true, plsql = true }
local function ensure_sql_commentstring(buf)
  if vim.api.nvim_buf_is_valid(buf)
    and sql_filetypes[vim.bo[buf].filetype]
    and vim.bo[buf].commentstring == ""
  then
    vim.bo[buf].commentstring = "-- %s"
  end
end

vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("SqlCommentString", { clear = true }),
  callback = function(event)
    ensure_sql_commentstring(event.buf)
    vim.schedule(function()
      ensure_sql_commentstring(event.buf)
    end)
  end,
})

return M
