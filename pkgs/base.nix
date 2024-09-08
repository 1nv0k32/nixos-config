{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    openssl
    git
    git-crypt
    bat
    tree
    file
    htop
    aria
    wget
    unzip
    fzf
  ];
}
