{ inputs, pkgs, ... }:
with pkgs;
let
  unstable = import (inputs.nixpkgs-unstable) { config = config.nixpkgs.config; };
in
{
  gnomeExtensions = [
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    gnomeExtensions.tiling-assistant
    gnomeExtensions.caffeine
    gnomeExtensions.unblank
    gnomeExtensions.astra-monitor
  ];
}

# vim:expandtab ts=2 sw=2
