{ inputs, ... }:
let
  overlayConfig = {
    config.allowUnfree = true;
  };
  pkgs-master = _: prev: {
    pkgs-master = import (inputs.nixpkgs-master) {
      inherit (prev.stdenv) system;
      inherit (overlayConfig) config;
    };
  };
in
{
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  nixpkgs = {
    inherit (overlayConfig) config;
    overlays = [ pkgs-master ];
  };
}
