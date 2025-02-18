{ pkgs, ... }:
{
  programs.bash = {
    completion.enable = true;
    shellInit = ''
      shopt -s histappend
      shopt -s globstar
      export HISTCONTROL=ignoreboth
      export HISTSIZE=-1
      export HISTFILESIZE=-1
    '';
    promptInit = ''
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
      PS1="$DoC[$WH$SHLVL:$SSH\u@\H$DoC]\`$PS_STAT\`$DoC[$PR\w$DoC]$WH \`$PS_GIT\` \n$PS_SH"
    '';
    shellAliases = {
      rm = "rm -I";
      ls = "ls --color=auto";
      ll = "ls -alhFb --group-directories-first";
      grep = "${pkgs.gnugrep}/bin/grep --color=auto";
      diff = "${pkgs.diffutils}/bin/diff --color=auto";
      cat = "${pkgs.bat}/bin/bat -p";
      nixup = "sudo ${pkgs.bash}/bin/bash -c 'nix flake update --flake path:/etc/nixos && nixos-rebuild switch'";
    };
  };
}
