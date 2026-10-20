return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            labels = "asdfghjklqwertyuiopzxcvbnm",
            highlight = {
                backdrop = true,
            },
            modes = {
                char = {
                    enabled = false,
                },
            },
        },
        keys = {
            {
                "e",
                mode = "n",
                function()
                    require("flash").jump()
                end,
                desc = "Flash 快速跳转",
            },
        },
    },
}

