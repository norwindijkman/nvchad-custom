---@type MappingsTable
local M = {}

M.nvimtree = {
  n = {
    -- close
    ["<C-n>"] = { "<cmd> NvimTreeClose <CR>", "Close nvimtree" },
  },
}


M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },

    --  format with conform
    ["<leader>fm"] = {
      function()
        require("conform").format()
      end,
      "formatting",
    },


    -- tabufline commands
    ["<leader>X"] = {
      function()
        require("nvchad.tabufline").closeOtherBufs()
      end,
      "Close other buffers",
    },
    ["<leader><Tab>"] = {
      function()
        require("nvchad.tabufline").move_buf(1)
      end,
      "Move buffer forward"
    },
    ["<leader><S-Tab>"] = {
      function()
        require("nvchad.tabufline").move_buf(-1)
      end,
      "move buffer back"
    },
    ["<leader>u"] = {
      function()
        if vim.opt.showtabline._value == 2 then
          vim.opt.showtabline = 0
        else
          vim.opt.showtabline = 2
        end
      end,
      "Toggle tabufline"
    }
  },
  v = {
    [">"] = { ">gv", "indent" },
  },
}

-- more keybinds!

return M
