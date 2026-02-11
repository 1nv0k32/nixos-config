{ lib, pkgs, ... }:
{
  imports = [
    ./bash.nix
    ./zsh.nix
  ];

  users.defaultUserShell = pkgs.zsh;

  environment.shellAliases = {
    rm = "rm -I";
    ls = "ls --color=auto";
    ll = "ls -alhFb --group-directories-first";
    grep = "${pkgs.gnugrep}/bin/grep --color=auto";
    diff = "${pkgs.diffutils}/bin/diff --color=auto";
    cat = "${pkgs.bat}/bin/bat -p";
    k = "${lib.getExe pkgs.kubectl}";
  };
}
