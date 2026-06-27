{
  nixpkgs,
  nixpkgs-master,
  nixpkgs-unstable,
  nixpkgs-old,
  ...
}:
let
  overlayConfig = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
  };
  master = _: prev: {
    master = import nixpkgs-master {
      inherit (prev.stdenv) system;
      inherit (overlayConfig) config;
    };
  };
  unstable = _: prev: {
    unstable = import nixpkgs-unstable {
      inherit (prev.stdenv) system;
      inherit (overlayConfig) config;
    };
  };
  old = _: prev: {
    old = import nixpkgs-old {
      inherit (prev.stdenv) system;
      inherit (overlayConfig) config;
    };
  };
in
{
  environment.variables = {
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
  nixpkgs = {
    inherit (overlayConfig) config;
    overlays = [
      master
      unstable
      old
    ];
  };
}
