{ config, pkgs, ... }:
let
  repo = builtins.fetchTarball https://github.com/1nv0k32/nixpkgs/tarball/kubeswitch-fix-name-and-shell-completion;
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

