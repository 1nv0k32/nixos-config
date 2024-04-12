{ config, pkgs, ... }:
let
  repo = builtins.fetchTarball https://github.com/NixOS/nixpkgs/tarball/master;
  repo_pkgs = import (repo) { config = config.nixpkgs.config; };
in
{
  imports = [
    (import "${repo}/nixos/modules/programs/kubeswitch.nix")
  ];

  programs.kubeswitch = {
    enable = true;
    package = repo_pkgs.kubeswitch;
  };
}

