-- Check if running inside VSCode
if vim.g.vscode then
  -- Load VSCode-specific configuration
  dofile(vim.fn.stdpath('config') .. '/vscode.lua')
  return -- Stop loading the rest of init.lua
end

vim.loader.enable()

local keys = dofile(vim.fn.stdpath('config') .. '/keys.lua')

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.wrap = true          -- enable visual wrapping
    vim.opt_local.linebreak = true     -- wrap at word boundaries, not mid-word
    vim.opt_local.breakindent = true   -- wrapped lines keep the same indent
    vim.opt_local.textwidth = 0        -- 0 = don't insert hard breaks, purely visual
  end,
})

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.mouse = 'a'
vim.opt.scroll = 5
vim.opt.autoindent = true
vim.opt.autowrite = true
vim.opt.showmode = false
vim.opt.signcolumn = 'yes'
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cursorline = true
vim.opt.scrolloff = 5
vim.opt.clipboard = "unnamedplus"

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}

-- plugins
local lazy = {}
function lazy.install(path)
  if not vim.loop.fs_stat(path) then
    print('Installing lazy.nvim ...')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path
    })
  end
end

function lazy.setup(plugins)
  if vim.g.plugins_ready then
    return
  end

  lazy.install(lazy.path)
  vim.opt.rtp:prepend(lazy.path)
  require('lazy').setup(plugins, lazy.opts)
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

lazy.setup({
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'dracula',
          sections = {
            lualine_a = {'mode', 'buffers'}
          }
        }
      }
    end
  },
  { 'numToStr/Comment.nvim', lazy = false },
  { 'windwp/nvim-autopairs', event = "InsertEnter", 
    opts = {
      disable_filetype = { "markdown" }
    }, lazy = false },
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup()
    end
  },
  { 'lewis6991/gitsigns.nvim' },
  {
    'ibhagwan/fzf-lua',
    config = function()
      require('fzf-lua').setup {
        winopts = {
          split = 'belowright new',
          fullscreen = true,
          layout = 'horizontal'

        }
      }
    end
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = { 
        preset = "super-tab", 
        ["<C-space>"] = {} ,
        ["<C-y>"] = { "show", "show_documentation", "hide_documentation" } 
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          markdown = { "lsp", "path", "snippets" }
        }
      },
      completion = {
        trigger = {
          show_on_blocked_trigger_characters = { "'", '"' },
          show_on_x_blocked_trigger_characters = {}
        }
      }
    }
  },
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "saghen/blink.cmp",
      "ibhagwan/fzf-lua",
    },
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "work",
          path = "~/delta-vault",
        },
        {
          name = "personal",
          path = "~/personal-vault",
        }
      },
      notes_subdir = "notes",
      daily_notes = {
        folder = "notes/daily"
      },
      mapping = {
        -- Toggle check-boxes.
        ["<leader>oc"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
      },
      new_notes_location = "notes_subdir",
      -- Optional, customize how note IDs are generated given an optional title.
      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,
    }
  },
})

-- Comment
require('Comment').setup()

-- gitsigns
require('gitsigns').setup()
