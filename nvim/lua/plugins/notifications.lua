return {
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      notifier = { enabled = true, timeout = 3000, style = "compact" },
      styles = {
        notification = { border = "rounded", wo = { winblend = 0 } },
        notification_history = { border = "rounded" },
      },
    },
    keys = {
      { "<leader>sn", function() Snacks.notifier.show_history() end, desc = "Notification history" },
      {
        "<leader>un",
        function()
          if package.loaded.noice then
            require("noice").cmd("dismiss")
          end
          Snacks.notifier.hide()
        end,
        desc = "Dismiss notifications",
      },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "folke/snacks.nvim" },
    opts = {
      notify = { enabled = true, view = "notify" },
      views = { notify = { backend = "snacks" } },
      lsp = {
        progress = { enabled = true, view = "notify" },
        -- Keep NvChad's existing documentation and signature handling.
        hover = { enabled = false },
        signature = { enabled = false },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
    keys = {
      { "<leader>snh", "<cmd>Noice history<cr>", desc = "Editor message history" },
      { "<leader>snl", "<cmd>Noice last<cr>", desc = "Last editor message" },
    },
  },
}
