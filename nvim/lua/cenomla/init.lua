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

-- Link the diagnostics colors to gruvbox colors
vim.cmd [[
	highlight! link DiagnosticError GruvboxRedBold
	highlight! link DiagnosticWarn GruvboxOrangeBold
	highlight! link DiagnosticInfo GruvboxYellowBold
	highlight! link DiagnosticHint GruvboxBlueBold
]]


-- Pretty statusline and tabline
function _G.statusline(current, width)
	local line = ""

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
	local vimLabel = "NVIM"
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
vim.g.crystalline_theme = "gruvbox"

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

-- lsp config

vim.diagnostic.config({
	underline = false,
	virtual_text = {
		spacing = 1,
	},
})

-- Highlight the line numbers for lines with diagnostic messages on them
vim.cmd [[
	sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticVirtualTextError
	sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticVirtualTextWarn
	sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticVirtualTextInfo
	sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticVirtualTextHint
]]

vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { silent=true })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { silent=true })
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, { silent=true })

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

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

