{ inputs, ... }:
let
  overlays = {
    pkgs-master = _: prev: {
      pkgs-master = import (inputs.nixpkgs-master) {
        inherit (prev.stdenv) system;
        config.allowUnfree = true;
      };
    };
    pkgs-unstable = _: prev: {
      pkgs-unstable = import (inputs.nixpkgs-unstable) {
        inherit (prev.stdenv) system;
        config.allowUnfree = true;
      };
    };
    pkgs-old = _: prev: {
      pkgs-old = import (inputs.nixpkgs-old) {
        inherit (prev.stdenv) system;
        config.allowUnfree = true;
      };
    };
  };
in
{
  nixpkgs.overlays = [
    overlays.pkgs-master
    overlays.pkgs-unstable
    overlays.pkgs-old
  ];
}

# vim:expandtab ts=2 sw=2
