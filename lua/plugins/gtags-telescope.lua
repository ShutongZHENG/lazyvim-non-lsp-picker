return {
  {
    "ukyouz/telescope-gtags",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension("gtags")
    end,
    keys = {
      {
        "gd",
        "<cmd>:Telescope gtags_definitions initial_mode=normal<cr>",
        desc = "Telescope Definitions (Gtags)",
      },
      {
        "gr",
        "<cmd>:let @/=expand('<cword>') | set hlsearch | Telescope gtags_references initial_mode=normal<cr>",
        desc = "Telescope References (Gtags)",
      },
    },
  },
}
