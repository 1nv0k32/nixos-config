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
  pkgs-unstable = _: prev: {
    pkgs-unstable = import (inputs.nixpkgs-unstable) {
      inherit (prev.stdenv) system;
      inherit (overlayConfig) config;
    };
  };
  pkgs-old = _: prev: {
    pkgs-old = import (inputs.nixpkgs-old) {
      inherit (prev.stdenv) system;
      inherit (overlayConfig) config;
    };
  };
in
{
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  nixpkgs = {
    inherit (overlayConfig) config;
    overlays = [
      pkgs-master
      pkgs-unstable
      pkgs-old
    ];
  };
}
