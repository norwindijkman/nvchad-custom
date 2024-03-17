local M = {}

M.blankline = {
  indentLine_enabled = 0,
}

M.gitsigns = {
  signs = {
    add = { text = "󰙴" },
    change = { text = "󰏫" },
    delete = { text = "-" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "󰙴" },
  },
}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "svelte",
    "tsx",
    "c",
    "php",
    "markdown",
    "markdown_inline",
    "dart"
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "svelte-language-server",
    "deno",
    "prettier",

    -- php stuff
   "intelephense",
   "twig",

    -- c/cpp stuff
    "clangd",
    "clang-format",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
      glyphs = {
        git = {
          unstaged = "󰏫",
          staged = "✓",
          unmerged = "",
          renamed = "󰏫",
          untracked = "󰙴",
          deleted = "",
          ignored = "◌"
        }
      }
    },
  },
}

return M
