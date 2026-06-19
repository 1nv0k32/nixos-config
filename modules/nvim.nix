{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    ripgrep
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    colorschemes.gruvbox.enable = true;
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    keymaps = [
      {
        mode = "";
        key = "<space>";
        action = "<nop>";
      }
      {
        mode = "";
        key = "<leader>n";
        action = ":NeoTree filesystem reveal";
      }
    ];
    opts = {
      number = true;
      relativenumber = false;
      guicursor = "n-v-c-sm:block,i-ci-ve:ver25-Cursor,r-cr-o:hor20";
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
      web-devicons.enable = true;
      lualine.enable = true;
      lazygit.enable = true;
      gitblame.enable = true;
      gitsigns.enable = true;
      indent-blankline.enable = true;
      lastplace.enable = true;
      treesitter.enable = true;
      nvim-autopairs.enable = true;
      helm.enable = true;
      blink-cmp.enable = true;
      which-key = {
        enable = true;
        settings = {
          spec = [
            {
              __unkeyed-1 = "<leader>f";
              group = "+Find/Files";
            }
            {
              __unkeyed-1 = "<leader>n";
              group = "+NeoTree";
            }
          ];
        };
      };
      telescope = {
        enable = true;
        keymaps = {
          "<leader>fg" = "git_files";
          "<leader>ff" = "live_grep";
        };
      };
      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
          filesystem = {
            follow_current_file = {
              enabled = true;
              leave_dirs_open = false;
            };
          };
          window = {
            position = "right";
            mappings = {
              "<space>" = "none";
              "h" = "close_node";
              "l" = "open";
            };
          };
        };
      };
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          clangd.enable = true;
          gopls.enable = true;
        };
      };
    };
  };
}
