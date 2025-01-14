{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    openssl
    git
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

    linuxPackages_latest.kernel.dev

    nixfmt-rfc-style
    nixd
    uv
    python312
  ];
}
