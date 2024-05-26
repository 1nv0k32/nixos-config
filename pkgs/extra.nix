{
  inputs,
  pkgs,
  ...
}:
let
  unstable = import (inputs.nixpkgs-unstable) {
    config = config.nixpkgs.config;
  };
in
{
  environment.systemPackages = with pkgs; [
    vscode
    win-virtio
    virt-manager
    vagrant
    krew
    distrobox
  ];
}

# vim:expandtab ts=2 sw=2
