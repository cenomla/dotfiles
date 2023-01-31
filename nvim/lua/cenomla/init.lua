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

require('packer').startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use("junegunn/fzf.vim")

	use("neovim/nvim-lspconfig")

	use("tpope/vim-dispatch")

	use("morhetz/gruvbox")

	use("ntpeters/vim-better-whitespace")

	use("rbong/vim-crystalline")

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

vim.cmd("runtime 'macros/matchit.vim'")

vim.opt.mouse = "a"

vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.g.gruvbox_constrast_dark = "medium"
vim.g.gruvbox_constrast_light = "medium"
vim.g.gruvbox_improved_strings = 1
vim.cmd("colorscheme gruvbox")

-- Pretty statusline and tabline
function _G.statusline(current, width)
	local line = ''

	if current == 1 then
		line = line .. vim.fn["crystalline#mode"]() .. "%#Crystalline#"
	else
		line = line .. "%#CrystallineInactive#"
	end
	line = line .. " %<%f%h%w%m%r "
	if current == 1 then
		line = line .. "%#CrystallineFill#"
	end

	line = line .. "%="

	if current == 1 then
		line = line .. "%= %{&paste ? 'PASTE ':''}%{&spell?'SPELL ':''}%#Crystalline#"
	end
	if width > 80 then
		line = line .. " %{&ft} | %{&fenc!=#''?&fenc:&enc} | %{&ff} %c%V %P(%L)"
	end
	line = line .. " "


	return line
end

function _G.tabline()
	local vimLabel = 'NVIM'
	return vim.fn["crystalline#bufferline"](2, #vimLabel + 1, 1) .. "%=%#CrystallineTab# " .. vimLabel .. " "
end

vim.api.nvim_exec([[
function! StatusLine(current, width)
	return v:lua.statusline(a:current, a:width)
endfunction

function! TabLine()
	return v:lua.tabline()
endfunction
]], false)

vim.g.crystalline_statusline_fn = "StatusLine"
vim.g.crystalline_tabline_fn = "TabLine"
vim.g.crystalline_theme = 'gruvbox'

vim.opt.laststatus = 2
vim.opt.signcolumn = "no"

-- render whitespace
vim.opt.listchars="eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣"

vim.g.mapleader = " "

-- Auto commands

vim.api.nvim_create_augroup("cusft", {})
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
	group = "cusft",
	pattern = {"*.glsl", "*.glslinc"},
	command = "set filetype=glsl",
})

vim.api.nvim_create_augroup("cuslang", {})
vim.api.nvim_create_autocmd("FileType", {
	group = "cuslang",
	pattern = "glsl",
	command = "set syntax=c",
})
vim.api.nvim_create_autocmd("FileType", {
	group = "cuslang",
	pattern = {"typescript", "typescriptreact"},
	command = "setlocal tabstop=2 expandtab",
})
vim.api.nvim_create_autocmd("FileType", {
	group = "cuslang",
	pattern = "dart",
	command = "setlocal tabstop=2 expandtab",
})

vim.api.nvim_create_augroup("cusmake", {})
vim.api.nvim_create_autocmd("FileType", {
	group = "cusmake",
	pattern = "markdown",
	command = "set makeprg=markdown\\ -f\\ fencedcode\\ -S\\ -o\\ /tmp/out.html\\ %",
})
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = "cusmake",
	pattern = "[^l]*",
	command = "cwindow",
	nested = true,
})
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = "cusmake",
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
vim.env.FZF_DEFAULT_COMMAND = "rg --files --hidden ."

-- Find similar file

vim.b.file_switch_regex = "^$"

function build_extension_regex(extensions)
	local regex = ""
	for i, ext in ipairs(extensions) do
		if regex ~= "" then
			regex = regex .. "\\|"
		end
		regex = regex .. "\\(\\." .. ext .. "$\\)"
	end
	return regex
end

vim.api.nvim_create_augroup("file_switch_set_regex", {})
vim.api.nvim_create_autocmd("FileType", {
	group = "file_switch_set_regex",
	pattern = "cpp",
	callback = function()
		vim.b.file_switch_regex = build_extension_regex({"h", "hpp", "hh", "hxx", "c", "cpp", "cxx", "cc"})
	end
})
vim.api.nvim_create_autocmd("FileType", {
	group = "file_switch_set_regex",
	pattern = "c",
	callback = function()
		vim.b.file_switch_regex = build_extension_regex({"h", "c"})
	end
})

function find_similar_file(name, pattern)
	local regex = vim.regex(pattern)
	local files = vim.fn.globpath(vim.o.path, name .. ".*", 0, 1)
	local matchFiles = {}
	local currentFile = vim.fn.expand("%")
	local mi = -1

	for i = #files, 1, -1 do
		local it = files[i]
		if regex:match_str(it) then
			if currentFile == it then
				mi = #matchFiles
			end
			table.insert(matchFiles, it)
		end
	end

	-- echo a:regex
	print(vim.inspect(matchFiles))

	if mi ~= -1 then
		vim.cmd("e " .. matchFiles[((mi + 1) % #matchFiles) + 1])
	end
end

-- Keybinds
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("i", "kj", "<ESC>")

-- C/C++ related binds
vim.keymap.set("n", "<leader>k", function() find_similar_file(vim.fn.expand("%:t:r"), vim.b.file_switch_regex) end)

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

-- lsp config

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		underline = false,
	}
)

vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { silent=true })

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local bufopts = { silent=true, buffer=bufnr }

	vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, bufopts)
end

require('lspconfig')['clangd'].setup({
	on_attach = on_attach,
})

require('lspconfig')['tsserver'].setup({
	on_attach = on_attach,
})
require('lspconfig')['dartls'].setup({
	on_attach = on_attach,
})

