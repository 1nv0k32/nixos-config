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
      guicursor = "n-v-c-sm:block,i-ci-ve:ver25-Cursor,r-CR-o:hor20";
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
      hlsearch = false;
      incsearch = true;
      termguicolors = true;
      scrolloff = 8;
      updatetime = 50;
      colorcolumn = "80";
    };
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };
    keymaps = [
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
      }
      {
        mode = "";
        key = "<space>";
        action = "<nop>";
      }
      {
        mode = "n";
        key = "<leader>fnr";
        action = ":Neotree filesystem reveal <CR>";
        options.desc = "Show Neotree";
      }
      {
        mode = "n";
        key = "<leader>fnc";
        action = ":Neotree filesystem close <CR>";
        options.desc = "Hide Neotree";
      }
      {
        mode = "n";
        key = "<leader>fv";
        action = ":LazyGit <CR>";
        options.desc = "Show LazyGit";
      }
      {
        mode = "n";
        key = "<leader>fw";
        action = ":w <CR>";
        options.desc = "Write to file";
      }
      {
        mode = "n";
        key = "<leader>fq";
        action = ":wqa <CR>";
        options.desc = "Write to file, Quit all";
      }
      # Telescope
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd> Telescope git_files <CR>";
        options.desc = "Open file in Git";
      }
      {
        mode = "n";
        key = "<leader>fa";
        action = "<cmd> Telescope find_files <CR>";
        options.desc = "Open file";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd> Telescope live_grep <CR>";
        options.desc = "Find in files";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd> Telescope buffers <CR>";
        options.desc = "Buffers";
      }
    ];
    lsp = {
      keymaps = [
        {
          key = "<leader>ld";
          lspBufAction = "definition";
        }
        {
          key = "<leader>lh";
          lspBufAction = "hover";
        }
      ];
    };
    plugins = {
      web-devicons.enable = true;
      lualine.enable = true;
      lazygit.enable = true;
      gitblame.enable = true;
      gitsigns.enable = true;
      indent-blankline.enable = true;
      treesitter.enable = true;
      nvim-autopairs.enable = true;
      blink-cmp.enable = true;
      telescope.enable = true;
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          gopls.enable = true;
        };
        keymaps = {

        };
      };
      which-key = {
        enable = true;
        settings = {
          spec = [
            {
              __unkeyed-1 = "<leader>f";
              group = "+Find/Files";
            }
            {
              __unkeyed-1 = "<leader>fn";
              group = "+Neotree";
            }
            {
              __unkeyed-1 = "<leader>l";
              group = "+LSP";
            }
          ];
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
    };
  };
}
