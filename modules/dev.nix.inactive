{ inputs, ... }:
let
  nixpkgs-unstable_pkgs = import (inputs.nixpkgs-unstable) { system = "x86_64-linux"; };
in
{
  imports = [
    (import "${inputs.nixpkgs-unstable}/nixos/modules/programs/kubeswitch.nix")
  ];

  programs.kubeswitch = {
    enable = true;
    package = nixpkgs-unstable_pkgs.kubeswitch;
  };
}
