-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
--- Set the default register for delete, change, etc., to the '+' (system clipboard)
--

-- Quickly create a note
function Create_date_file()
  local date_str = os.date "%Y-%m-%d"
  local file_path = "~/softw/penguin/notes/note-" .. date_str .. ".md" -- Change the directory as needed
  local command = "edit " .. file_path
  vim.api.nvim_command(command)
end
vim.api.nvim_set_keymap("n", "<Leader>cn", ":lua Create_date_file()<CR>", { noremap = true, silent = true })

-- Set line wrap on
vim.wo.wrap = false
function ToggleWrap()
  local wrap = vim.wo.wrap
  vim.wo.wrap = not wrap
end
vim.api.nvim_set_keymap("n", "<leader>l", ":lua ToggleWrap()<CR>", { noremap = true, silent = true })

-- Turn line numbers off
vim.wo.number = false

-- nvim-tree live grep
function GrepInNvimTreeFolder()
  local nimvTree = require "nvim-tree.api"
  local node = nimvTree.tree.get_node_under_cursor()
  local path
  if node and node.type == "directory" then
    path = node.absolute_path
  elseif node and node.type == "file" then
    path = vim.fn.fnamemodify(node.absolute_path, ":h")
  end
  if path then
    require("telescope.builtin").live_grep { search_dirs = { path } }
  end
end

-- Bind the function to a key
vim.api.nvim_set_keymap("n", "<leader>pp", ":lua GrepInNvimTreeFolder()<CR>", { noremap = true, silent = true })

vim.g.indent_blankline_char = ""
-- vim.cmd([[IndentBlanklineRefresh]])

-- Scroll faster
vim.api.nvim_set_keymap("n", "<A-j>", "4j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-k>", "4k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-j>", "4j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-k>", "4k", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<C-A-j>", "16j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-A-k>", "16k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-A-j>", "16j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-A-k>", "16k", { noremap = true, silent = true })

vim.schedule(function()
  vim.opt.showtabline = 0
end)




function AddToRecentFiles()
  local filePath = vim.fn.expand('%:p')
  local dateCmd = "date --iso-8601=seconds"
  local gioCmd = "gio set -t string " .. filePath .. " metadata::recent-info $(" .. dateCmd .. ")"
  vim.fn.system(gioCmd)
end

vim.api.nvim_create_user_command('SR', AddToRecentFiles, {})

local function make_recent()
  local filepath = vim.fn.expand('%:p')
  local uri = 'file://' .. filepath
  local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
  local dateCmd = "date --iso-8601=seconds"
  local gioCmd = "gio set -t string " .. filepath .. " metadata::recent-info $(" .. dateCmd .. ")"

  vim.fn.system(gioCmd)

  local new_entry = string.format(
      '  <bookmark href="%s" added="%s" modified="%s" visited="%s">\n' ..
      '    <info>\n' ..
      '      <metadata owner="http://freedesktop.org">\n' ..
      '        <mime:mime-type type="text/plain"/>\n' ..
      '        <bookmark:applications>\n' ..
      '          <bookmark:application name="Neovim" exec="nvim \'%s\'" modified="%s" count="1"/>\n' ..
      '        </bookmark:applications>\n' ..
      '      </metadata>\n' ..
      '    </info>\n' ..
      '  </bookmark>\n',
      uri, timestamp, timestamp, timestamp, filepath, timestamp)

  local recently_used_file = os.getenv("HOME") .. '/.local/share/recently-used.xbel'
  local file = io.open(recently_used_file, "r+")
  if file then
      local content = file:read("*all")
      
      -- Check if the bookmark already exists
      local escaped_uri = uri:gsub("([^%w])", "%%%1")
      local pattern = '<bookmark href="' .. escaped_uri .. '"[^>]*>.-</bookmark>'
      local exists = content:match(pattern)

      -- print(pattern, exists)

      if exists then
          -- Update the existing bookmark
          content = content:gsub(pattern, new_entry)
      else
          -- Insert a new bookmark
          content = content:gsub('</xbel>', new_entry .. '</xbel>')
      end

      file:seek("set")
      file:write(content)
      file:close()
  else
      print("Error: Unable to open recently-used.xbel")
  end
end

vim.api.nvim_create_user_command('MakeRecent', make_recent, {})
vim.api.nvim_create_user_command('MR', make_recent, {})

-- Toggle nvim-tree width between wide / thin view
function toggleNvimTreeWidth()
  local view = require('nvim-tree.view')
  local standard_width = 30
  local wide_width = 60

  if view.View.width == standard_width then
    view.resize(wide_width)
  else
    view.resize(standard_width)
  end
end

vim.api.nvim_set_keymap('n', '<Leader>tw', '<cmd>lua toggleNvimTreeWidth()<CR>', { noremap = true, silent = true })

local function goToNextFileInDir()
    local current_file = vim.fn.expand('%:p')
    -- Get all files in the current directory
    local file_pattern = vim.fn.expand('%:h')
    if type(file_pattern) == 'string[]' then
      return
    end
    local files_unsorted = vim.fn.globpath(file_pattern, '*', false, true)

    if type(files_unsorted) == 'string' then
        -- If globpath returns a string array (unlikely with these arguments), return
        files_unsorted = {files_unsorted}
    end

    -- Sort the files alphabetically
    local files = vim.fn.sort(files_unsorted)

    -- Find the current file and determine the next file to edit
    local next_file_index = nil
    for i, file in ipairs(files) do
        if file == current_file then
            print(file)
            next_file_index = (i % #files) + 1
            break
        end
    end
    print(next_file_index)

    if next_file_index then
        -- Edit the next file
        vim.cmd('edit ' .. vim.fn.fnameescape(files[next_file_index]))
    end
end

vim.api.nvim_create_user_command('NextFile', goToNextFileInDir, {})
