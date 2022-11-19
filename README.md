# dotfiles
Linux configuration

## Dependencies
 - Git
 - Neovim
   - Install [Packer](https://github.com/wbthomason/packer.nvim) for nvim
 - zsh
   - zsh-completions
   - zsh-syntax-highlighting
 - fzf
 - rg
 - Kitty

## Installation
 - Add the following lines to your nvim config:

```lua
vim.opt.rtp:append("<path-to-dotfiles>/nvim")
require("cenomla")
```

 - Copy `kitty.conf` to `~/.config/kitty/kitty.conf`
 - Source `zshrc` from your zshrc file
 - Source `zshenv` from your zshenv file
