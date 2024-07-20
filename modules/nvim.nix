{ lib, pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    colorschemes.vscode.enable = true;
    opts = {
      number = true;
      relativenumber = true;
      undofile = true;
      encoding = "utf-8";
      signcolumn = "yes";
      belloff = "all";
      wrap = false;
      wildmenu = true;
      modeline = true;
      modelines = 1;
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smarttab = true;
      autoindent = true;
    };
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };
    plugins = {
      lightline.enable = true;
      indent-blankline.enable = true;
      lastplace.enable = true;
      treesitter.enable = true;
      nvim-autopairs.enable = true;
      cmp.enable = true;
      lsp = {
        enable = true;
        servers = { };
      };
    };
  };
}

# vim:expandtab ts=2 sw=2
