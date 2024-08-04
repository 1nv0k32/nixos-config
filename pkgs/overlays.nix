{ inputs, system, ... }:
let
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
in
{
  nixpkgs = {
    pkgs = import inputs.nixpkgs { config.allowUnfree = true; };
    overlays = [
      pkgs-master
      pkgs-unstable
      pkgs-old
    ];
  };
}

# vim:expandtab ts=2 sw=2
