{ lib, ... }:
with lib;
{
  programs = {
    nixvim = {
      enable = mkDefault true;
      viAlias = mkDefault true;
      vimAlias = mkDefault true;
      colorschemes.vscode.enable = true;
      plugins.lightline.enable = true;
      extraConfigVim = mkDefault ''
        syntax enable
        filetype indent on
        set guicursor=
        set mouse=a
        set encoding=utf-8
        set belloff=all
        set tabstop=2
        set softtabstop=2
        set shiftwidth=2
        set expandtab
        set smarttab
        set nonumber
        set wildmenu
        set foldenable
        set clipboard=unnamedplus
        set nowrap
        set modeline
        set modelines=1
      '';
    };
  };
}

# vim:expandtab ts=2 sw=2
