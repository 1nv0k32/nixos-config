{ inputs, pkgs, ... }:
with pkgs;
let
  unstable = import (inputs.nixpkgs-unstable) { config = config.nixpkgs.config; };
in
{
  gnomeExtensions = with gnomeExtensions; [
    appindicator
    just-perfection
    tiling-assistant
    caffeine
    unblank
    astra-monitor
  ];
}

# vim:expandtab ts=2 sw=2
