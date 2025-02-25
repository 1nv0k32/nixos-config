{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    openssl
    sops
    git-crypt
    tree
    file
    htop
    aria
    wget
    dig
    unzip
    kubectl
    jq
    yq

    nixd
    uv
    python312
  ];
}
