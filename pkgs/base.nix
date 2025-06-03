{ pkgs, ... }:
{
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
    uv
    python312
  ];
}
