{ lib, ... }:
with lib;
{
  programs = {
    nixvim = {
      enable = mkDefault true;
      viAlias = mkDefault true;
      vimAlias = mkDefault true;
      colorschemes.vscode.enable = true;
      opts = {
        number = true;
        relativenumber = true;
        tabstop = mkDefault 2;
        softtabstop = mkDefault 2;
        shiftwidth = mkDefault 2;
        expandtab = true;
        smarttab = true;
      };
      plugins = {
        lightline.enable = mkDefault true;
        telescope.enable = mkDefault true;
        lastplace.enable = mkDefault true;
        oil.enable = mkDefault true;
        lsp = {
          enable = mkDefault true;
          servers = {
            nixd.enable = mkDefault true;
          };
        };
      };
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
