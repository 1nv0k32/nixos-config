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
    keymaps = [
      {
        mode = "";
        key = "<space>";
        action = "<nop>";
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = ":Neotree filesystem reveal <cr>";
      }
      {
        mode = "n";
        key = "<leader>fw";
        action = ":w <cr>";
      }
      {
        mode = "n";
        key = "<leader>fq";
        action = ":wqa <cr>";
      }
    ];
    plugins = {
      web-devicons.enable = true;
      lualine.enable = true;
      bufferline.enable = true;
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
          ];
        };
      };
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "git_files";
          "<leader>fg" = "live_grep";
        };
      };
      toggleterm = {
        enable = true;
        settings = {
          direction = "float";
          open_mapping = "[[<c-\\>]]";
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
