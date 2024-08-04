{ lib, ... }:
{
  imports =
    [ ]
    ++ lib.optional (builtins.pathExists ./dev.nix) (import ./dev.nix)
    ++ [
      ./sysconf.nix
      ./flake-auto.nix
      ./nvim.nix
      ./tmux.nix
      ./cert-der.nix
      ./alpaca.nix
    ];
}

# vim:expandtab ts=2 sw=2
