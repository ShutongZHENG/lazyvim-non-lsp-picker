-- lua/plugins/completion-blink.lua
return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "niuiic/blink-cmp-rg.nvim",
    },

    opts = {
      sources = {
        default = { "path", "snippets", "buffer", "ripgrep" },

        providers = {
          ripgrep = {
            module = "blink-cmp-rg",
            name = "Ripgrep",
            opts = {
              prefix_min_len = 3,
              get_command = function(context, prefix)
                return {
                  "rg",
                  "--no-config",
                  "--json",
                  "--word-regexp",
                  "--ignore-case",
                  "--",
                  prefix .. "[\\w_-]+",
                  vim.fs.root(0,".repo") or vim.fs.root(0, ".git") or vim.fn.getcwd(),
                }
              end,
              get_prefix = function(context)
                return context.line:sub(1, context.cursor[2]):match("[%w_-]+$") or ""
              end,
            },
          },
        },
      },

    },
  },
}
