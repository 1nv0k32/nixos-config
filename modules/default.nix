{ lib, ... }:
{
  imports =
    [ ]
    ++ lib.optional (builtins.pathExists ./dev.nix) (import ./dev.nix)
    ++ [
      ./sysconf.nix
      ./nvim.nix
      ./tmux.nix
      ./git.nix
      ./firefox.nix
    ];
}
