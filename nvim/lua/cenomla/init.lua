vim.cmd("filetype off")

local ensure_packer = function()
  local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
    vim.cmd("packadd packer.nvim")
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use("junegunn/fzf")
	use("junegunn/fzf.vim")

	use("neovim/nvim-lspconfig")

	use("tpope/vim-dispatch")

	use("ellisonleao/gruvbox.nvim")

	use("ntpeters/vim-better-whitespace")

	use("rbong/vim-crystalline")

	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local tsUpdate = require('nvim-treesitter.install').update({ with_sync = true })
			tsUpdate()
		end,
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)

vim.cmd("filetype plugin indent on")

--General settings
vim.opt.ruler = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showcmd = true
vim.opt.incsearch = true
vim.opt.hlsearch = false

vim.opt.tabstop = 4 -- Tab characters appear 4 spaces wide
vim.opt.softtabstop = -1 -- Use shiftwidth spaces when converting tabs to spaces
vim.opt.expandtab = false -- Always insert tabs when the tab key is pressed
vim.opt.shiftwidth = 0 -- Indents are the same width as tabs

vim.opt.linebreak = true -- Don't split up words on soft wrap
vim.opt.colorcolumn = {115} -- Render a line at the line character limit

vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 100
vim.opt.display = "truncate"
vim.opt.scrolloff = 5

vim.opt.nrformats = "bin,hex,octal"

-- Search subdirs from cwd
vim.opt.path = ".,,**"

vim.opt.hidden = true
-- Keep directories clean
vim.opt.backup = false
vim.opt.undofile = false

vim.cmd("syntax on")

vim.opt.mouse = "a"

vim.opt.termguicolors = true
vim.opt.background = "dark"

require("gruvbox").setup({
	terminal_colors = true,
	bold = false,
	italic = {
		strings = false,
		emphasis = false,
		comments = false,
		operators = false,
		folds = true,
	},
	overrides = {
		String = { fg = "#ebdbb2", bg = "#3c3836" },
		Function = { link = "Normal" },
		Delimiter = { link = "Normal" },
		["@type"] = { link = "Normal" },
		["@type.builtin"] = { link = "Normal" },
		["@type.qualifier"] = { link = "Special" },
		["@keyword.directive"] = { link = "PreProc" },
		["@keyword.import"] = { link = "PreProc" },
		["@keyword.conditional.ternary"] = { link = "Operator" },
		["@lsp.type.parameter"] = { link = "Normal" },
	}
})
vim.cmd("colorscheme gruvbox")

require("nvim-treesitter.configs").setup({
	auto_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

-- Open a floating window with a temp buffer containing a string
local function OpenTmpFloating(contents)
	local function SplitLines (inputstr, sep)
		if sep == nil then
			sep = "%s"
		end
		local t={}
		for str in string.gmatch(inputstr, '([^'..sep..']+)') do
			table.insert(t, str)
		end
		return t
	end

	local width = vim.api.nvim_win_get_width(0)
	local height = vim.api.nvim_win_get_height(0)

	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, SplitLines(contents, '%c'))

	local opts = {
		relative='win',
		win=0,
		width=width,
		height=height-1,
		col = 0,
		row = 0,
		anchor = 'NW',
		style = 'minimal',
		border = 'rounded',
	}

	local win = vim.api.nvim_open_win(bufnr, 1, opts)
	vim.api.nvim_win_set_option(win, 'winhl', 'NormalFloat:Normal')
	vim.api.nvim_win_set_option(win, 'wrap', false)
end

local function ShellStdout(command)
	local file = assert(io.popen(command, 'r'))
	file:flush()
	local result = file:read('*all')
	file:close()
	return result
end

local function GitBlame()
	local r,c = unpack(vim.api.nvim_win_get_cursor(0))
	local startLine = r-10
	if startLine < 1 then
		startLine = 1
	end
	local lineCount = vim.api.nvim_win_get_height(0)-1
	if lineCount < 1 then
		lineCount = 1
	end
	local command = 'git blame --date=short -L '..startLine..',+'..lineCount..' '..vim.api.nvim_buf_get_name(0)
	local blame = ShellStdout(command)
	OpenTmpFloating(blame)
end

-- Pretty statusline and tabline

local function CrystallineGroupSuffix()
	if vim.fn.mode() == 'i' and vim.o.paste then
		return "2"
	end
	if vim.o.modified then
		return "1"
	end
	return ""
end

function vim.g.CrystallineStatuslineFn(winnr)
	local cl = require("crystalline")
	vim.g.crystalline_group_suffix = CrystallineGroupSuffix()
	local isCurrent = winnr == vim.fn.winnr()
	local s = ""

	if isCurrent then
		s = s .. cl.ModeHiItem("A") .. cl.ModeLabel() .. cl.HiItem("B")
	else
		s = s .. cl.HiItem("Fill")
	end
	s = s .. " %<%f%h%w%m%r "

	if isCurrent then
		s = s .. cl.HiItem("Fill")
	end

	s = s .. "%="

	if isCurrent then
		s = s .. cl.HiItem("B") .. "%{&paste ? ' PASTE ' : ' '}"
		s = s .. cl.HiItem("B") .. "%{&spell ? ' SPELL ' : ' '}"
		s = s .. cl.HiItem("A")
	end
	if vim.fn.winwidth(winnr) then
		s = s .. " %{&ft} | %{&fenc!=#''?&fenc:&enc} | %{&ff} %c%V %P(%L)"
	end
	s = s .. " "


	return s
end

function vim.g.CrystallineTablineFn()
	local cl = require("crystalline")
	local maxWidth = vim.o.columns
	local right = "%="

	right = right .. cl.HiItem("TabType")
	maxWidth = maxWidth - 1

	local vimLabel = " NVIM"
	right = right .. vimLabel
	maxWidth = maxWidth - vim.fn.strchars(vimLabel)

	return cl.DefaultTabline({
		max_tabs = 23,
		max_width = maxWidth,
	}) .. right
end

vim.g.crystalline_theme = "gruvbox"

vim.opt.laststatus = 2
vim.opt.signcolumn = "no"

-- render whitespace
vim.opt.listchars="eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣"

vim.g.mapleader = " "

-- Auto commands

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
	pattern = {"*.glsl", "*.glslinc"},
	command = "set filetype=glsl",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = {"typescript", "typescriptreact", "dart", "javascript", "javascriptreact"},
	command = "setlocal tabstop=2 expandtab",
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	pattern = "[^l]*",
	command = "cwindow",
	nested = true,
})
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	pattern = "l*",
	command = "lwindow",
	nested = true,
})

-- Better whitespace config
vim.g.better_whitespace_enabled = 1
vim.g.strip_max_file_size = 0
vim.g.strip_whitespace_confirm = 0
vim.g.strip_whitespace_on_save = 1
vim.g.show_spaces_that_precede_tabs = our

-- Fzf config
vim.g.fzf_command_prefix = "Fzf"
vim.env.FZF_DEFAULT_COMMAND = "rg --files --path-separator=/ --hidden ."

-- Copilot config
vim.g.copilot_filetypes = {
	["*"] = false,
	["typescript"] = true,
	["typescriptreact"] = true,
}

-- Keybinds
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("i", "kj", "<ESC>")

-- Build/run related binds
vim.keymap.set("n", "<leader>r", ":Make<CR>")

-- Format with format prg
-- mg - set mark g to cursor
-- gg - move to first line
-- gqG - format to last line
-- 'g - move back to mark
vim.keymap.set("n", "<leader>p", "mggggqG'g")

-- Key bind for showing all project todos
vim.keymap.set("n", "<leader>t", ":cexpr system('rg -n TODO')<CR>")

-- FZF binds
vim.keymap.set("n", "<leader>ff", ":FzfFiles<CR>")
vim.keymap.set("n", "<leader>fb", ":FzfBuffers<CR>")
vim.keymap.set("n", "<leader>fl", ":FzfBLines<CR>")
vim.keymap.set("n", "<leader>fL", ":FzfLines<CR>")
vim.keymap.set("n", "<leader>fc", ":FzfCommands<CR>")
vim.keymap.set("n", "<leader>fr", ":FzfRg<CR>")

-- Git binds
vim.keymap.set("n", "<leader>gb", GitBlame)

-- lsp config

vim.diagnostic.config({
	underline = false,
	virtual_text = {
		spacing = 1,
	},
})

vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { silent=true })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { silent=true })
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, { silent=true })

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Disable lsp highlighting
	--client.server_capabilities.semanticTokensProvider = nil

	local bufopts = { silent=true, buffer=bufnr }

	local function switch_source_header()
		local params = {uri = vim.uri_from_bufnr(0)}
		client.request("textDocument/switchSourceHeader", params, function(err, result)
			if err then
				error(tostring(err))
			end
			if not result then
				print("Corresponding file not found")
				return
			end
			vim.cmd("edit " .. vim.uri_to_fname(result))
		end, 0)
	end

	vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format{ async = true } end, bufopts)
	if client.name == "clangd" then
		vim.keymap.set("n", "<leader>lk", switch_source_header, bufopts)
	end
end

require("lspconfig")["clangd"].setup({
	on_attach = on_attach,
})

require("lspconfig")["tsserver"].setup({
	on_attach = on_attach,
})
require("lspconfig")["dartls"].setup({
	on_attach = on_attach,
})

