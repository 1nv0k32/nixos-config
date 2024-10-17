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
    unzip
    kubectl
  ];
}
