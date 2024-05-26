{ lib, ... }:
{
  imports =
    [ ]
    ++ lib.optional (builtins.pathExists ./dev.nix) ./dev.nix
    ++ [
      ./sysconf.nix
      ./cert-der.nix
      ./alpaca.nix
    ];
}

# vim:expandtab ts=2 sw=2
