{ lib, ... }:
{
  imports =
    [ ]
    ++ lib.optional (builtins.pathExists ./dev.nix) (import ./dev.nix)
    ++ [
      ./sysconf.nix
      ./nvim.nix
      ./tmux.nix
      ./gpg.nix
      ./git.nix
      ./ssh.nix
      ./fzf.nix
      ./firefox.nix
    ];
}
