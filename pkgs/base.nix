{ pkgs, ... }:
{
  imports = [
    (import ./scripts.nix)
  ];

  environment.systemPackages = with pkgs; [
    git
    openssl
    nixos-anywhere
    sops
    git-crypt
    tree
    file
    htop
    aria
    wget
    dig
    screen
    unzip
    kubectl
    jq
    yq
    wireguard-tools
    nixd
  ];
}
