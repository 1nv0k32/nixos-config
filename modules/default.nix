{ lib, ... }:
{
  imports =
    [ ]
    ++ lib.optional (builtins.pathExists ./dev.nix) (import ./dev.nix)
    ++ [
      ./sysconf.nix
      ./nvim.nix
      ./tmux.nix
    ];
}

# vim:expandtab ts=2 sw=2
