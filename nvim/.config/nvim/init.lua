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
vim.opt.expandtab = false
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
	{ 'nvim-lualine/lualine.nvim',
	  config = function() require('lualine').setup() end
	},
	{ 'numToStr/Comment.nvim', lazy = false },
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
					path = "~/Delta",
				},
				{
					name = "personal",
					path = "~/personal-vault",
				}
			}
		}
	},
})

-- Comment
require('Comment').setup()

-- gitsigns
require('gitsigns').setup()
