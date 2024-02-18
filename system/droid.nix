{ lib, pkgs, ... }:
{
  system.stateVersion = "23.05";

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  time.timeZone = "CET";

  environment = {
    etcBackupExtension = ".bak";
    packages = with pkgs; [
      bash
      bash-completion
      openssh
      diffutils
      findutils
      utillinux
      tzdata
      hostname
      man
      gnugrep
      gnupg
      gnused
      gnutar
      bzip2
      gzip
      xz
      zip
      unzip
      tmux
      openssl
      git
      git-crypt
      nixpkgs-fmt
      tree
      bat
      file
      wget
      aria
      curl
      unzip
      unrar-wrapper
      jq
      yq
      gnumake
      cmake
      kubectl
      k9s
      terraform
      ansible
      python3
      poetry
      openvscode-server
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    config =
      { config, lib, pkgs, ... }: {
        home.stateVersion = "23.05";
        programs.readline = {
          enable = true;
          extraConfig = ''
            set completion-ignore-case on
            set colored-completion-prefix on
            set skip-completed-text on
            set visible-stats on
            set colored-stats on
            set mark-symlinked-directories on
          '';
        };
        programs.bash = {
          enable = true;
          enableCompletion = true;
          shellAliases = {
            cat = "bat";
          };
          bashrcExtra = ''
            shopt -s histappend
            shopt -s globstar
            export HISTCONTROL=ignoreboth
            export HISTSIZE=1000
            export HISTFILESIZE=2000
            source ${pkgs.git}/share/bash-completion/completions/git-prompt.sh
            WH="\[\e[0;00m\]"
            RE="\[\e[0;31m\]"
            GR="\[\e[0;32m\]"
            PR="\[\e[0;35m\]"
            CY="\[\e[0;36m\]"

            PS_STAT="[ \$? = "0" ] && printf '$GR*$WH' || printf '$RE*$WH'"
            PS_GIT="[ -z \$(__git_ps1 %s) ] && printf ' ' || __git_ps1 '$CY{%s}$WH'"
            if [ "`id -u`" -eq 0 ]; then
              DoC=$RE
              PS_SH="$RE# $WH"
            else
              DoC=$GR
              PS_SH="$GR$ $WH"
            fi
            PS1="$DoC[$WH\t$DoC]-[$WH\u@\H$DoC]\`$PS_STAT\`$DoC[$PR\w$DoC]$WH \`$PS_GIT\` \n$PS_SH"

            alias rm='rm -I'
            alias ls='ls --color=auto'
            alias ll='ls -alhFb --group-directories-first'
            alias grep='grep --color=auto'
            alias diff='diff --color=auto'
          '';
        };
        programs.tmux = {
          enable = true;
          extraConfig = ''
            bind -r C-a send-prefix
            bind -  split-window -v  -c '#{pane_current_path}'
            bind \\ split-window -h  -c '#{pane_current_path}'
            bind -r C-k resize-pane -U
            bind -r C-j resize-pane -D
            bind -r C-h resize-pane -L
            bind -r C-l resize-pane -R
            bind -r k select-pane -U
            bind -r j select-pane -D
            bind -r h select-pane -L
            bind -r l select-pane -R


            bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe
            bind -T copy-mode-vi Enter send-keys -X copy-pipe

            set -g base-index 1
            set -g mode-keys vi
            set -g prefix C-a
            set -g history-limit 50000
            set -g set-titles on
            set -g mouse on
            set -g monitor-activity on
            set -g default-terminal "xterm-256color"
            set -g default-command "''${SHELL}"
            set -s set-clipboard external
            set -ga terminal-overrides ",*256col*:Tc"
            set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
            set -g status-interval 60
            set -g status-bg black
            set -g status-fg green
            set -g window-status-activity-style fg=red
            set -g status-left-length 100
            set -g status-left  '#{?client_prefix,#[fg=red]PFX,   } #[fg=green](#S) '
            set -g status-right-length 100
            set -g status-right '#[fg=yellow]%Y/%m(%b)/%d %a %H:%M#[default]'
            set -g pane-border-lines double
            set -g clock-mode-style 24

            set-environment -g COLORTERM "truecolor"
          '';
        };
        programs.vim = {
          enable = true;
          extraConfig = ''
            syntax enable
            filetype indent on
            set mouse=a
            set encoding=utf-8
            set belloff=all
            set tabstop=2
            set softtabstop=2
            set shiftwidth=2
            set expandtab
            set smarttab
            set number
            set wildmenu
            set foldenable
            set clipboard=unnamedplus
            set nowrap
            set modeline
            set modelines=1
          '';
        };
      };
  };
}

# vim:expandtab ts=2 sw=2

