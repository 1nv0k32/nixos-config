{
  modulesPath,
  pkgs,
  lib,
  ...
}:
{
  RESOLVED_CONFIG = lib.mkDefault ''
    [Resolve]
    #DNS=
    #Domains=
    MulticastDNS=yes
    Cache=no
    CacheFromLocalhost=no
    DNSStubListener=yes
  '';

  SYSTEMD_CONFIG = lib.mkDefault ''
    [Manager]
    LogLevel=err
    DefaultTimeoutStartSec=30s
    DefaultTimeoutStopSec=30s
    DefaultDeviceTimeoutSec=30s
    DefaultMemoryAccounting=yes
    DefaultTasksAccounting=yes
  '';

  SYSTEMD_USER_CONFIG = lib.mkDefault ''
    [Manager]
    DefaultTimeoutStartSec=30s
    DefaultTimeoutStopSec=30s
  '';

  LOGIND_CONFIG = lib.mkDefault ''
    IdleAction=ignore
    IdleActionSec=3600
  '';

  INPUTRC_CONFIG = lib.mkForce (
    builtins.readFile "${modulesPath}/programs/bash/inputrc"
    + ''
      set completion-ignore-case on
      set colored-completion-prefix on
      set skip-completed-text on
      set visible-stats on
      set colored-stats on
      set mark-symlinked-directories on
    ''
  );

  BASHRC_CONFIG = lib.mkDefault ''
    shopt -s histappend
    shopt -s globstar
    export HISTCONTROL=ignoreboth
    export HISTSIZE=1000
    export HISTFILESIZE=2000

    # git prompt
    source ${pkgs.git}/share/bash-completion/completions/git-prompt.sh
    WH="\[\e[0;00m\]"
    RE="\[\e[0;31m\]"
    GR="\[\e[0;32m\]"
    PR="\[\e[0;35m\]"
    CY="\[\e[0;36m\]"

    PS_STAT="[ \$? = "0" ] && printf '$GR*$WH' || printf '$RE*$WH'"
    PS_GIT="[ -z \"\$(__git_ps1 %s)\" ] && printf ' ' || __git_ps1 '$CY{%s}$WH'"
    if [ "`id -u`" -eq 0 ]; then
      DoC=$RE
    else
      DoC=$GR
    fi
    test $SSH_TTY && SSH="SSH: "
    PS_SH="$DoC$ $WH"
    PS1="$DoC[$WH$SSH\u@\H$DoC]\`$PS_STAT\`$DoC[$PR\w$DoC]$WH \`$PS_GIT\` \n$PS_SH"

    alias rm='rm -I'
    alias ls='ls --color=auto'
    alias ll='ls -alhFb --group-directories-first'
    alias grep='grep --color=auto'
    alias diff='diff --color=auto'
  '';
}
