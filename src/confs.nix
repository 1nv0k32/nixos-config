{ pkgs, lib }:
with lib;
{
  NIX_CONFIG = mkDefault ''
    tarball-ttl = 0
  '';

  NETWORK_MANAGER_CONFIG = mkDefault ''
    [main]
    dns=systemd-resolved
    no-auto-default=*
    systemd-resolved=true
  '';

  RESOLVED_CONFIG = mkDefault ''
    [Resolve]
    #DNS=
    #Domains=
    DNSSEC=no
    #DNSOverTLS=no
    MulticastDNS=no
    LLMNR=no
    Cache=no
    CacheFromLocalhost=no
    DNSStubListener=no
  '';

  SYSTEMD_CONFIG = mkDefault ''
    [Manager]
    LogLevel=err
    RuntimeWatchdogSec=off
    RebootWatchdogSec=off
    KExecWatchdogSec=off
    DefaultTimeoutStartSec=10s
    DefaultTimeoutStopSec=10s
    DefaultDeviceTimeoutSec=10s
  '';

  SYSTEMD_USER_CONFIG = mkDefault ''
    [Manager]
    DefaultTimeoutStartSec=10s
    DefaultTimeoutStopSec=10s
  '';

  LOGIND_CONFIG = mkDefault ''
    IdleAction=ignore
    IdleActionSec=60
  '';

  INPUTRC_CONFIG = mkForce (
    builtins.readFile <nixpkgs/nixos/modules/programs/bash/inputrc>
    +
    ''
      set completion-ignore-case on
      set colored-completion-prefix on
      set skip-completed-text on
      set visible-stats on
      set colored-stats on
      set mark-symlinked-directories on
    ''
  );

  BASHRC_CONFIG = mkDefault ''
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

  VIMRC_CONFIG = mkDefault ''
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

  SSH_CLIENT_CONFIG = mkDefault ''
    Host *
      IdentitiesOnly yes
      ServerAliveInterval 60
  '';

  TMUX_CONFIG = mkDefault ''
    bind -r C-a send-prefix
    bind r source-file /etc/tmux.conf
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
    #set -g escape-time 0
    set -g mode-keys vi
    set -g prefix C-a
    set -g history-limit 50000
    #set -g set-titles on
    #set -g mouse on
    set -g monitor-activity on
    set -g default-terminal "xterm-256color"
    set -g default-command "''${SHELL}"
    set -s set-clipboard external
    set -g copy-command "${pkgs.wl-clipboard}/bin/wl-copy"
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
}

# vim:expandtab ts=2 sw=2
