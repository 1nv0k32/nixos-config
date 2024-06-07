{
  inputs,
  system,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [
    (import ../src/extra.nix)
    (import ../pkgs/extra.nix)
    (import ../overlays/initrd-luks.nix)
  ];
}

# vim:expandtab ts=2 sw=2
