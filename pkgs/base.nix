{ inputs, system, config, pkgs, ... }:
let
  unstable = import (inputs.nixpkgs-unstable) {
    inherit system; inherit config;
  };
in
{
  environment.systemPackages = with pkgs; [
    nixos-generators
    nixfmt-rfc-style
    cryptsetup
    openssl
    git
    tmux
    bat
    tree
    file
    htop
    btop
    acpi
    efibootmgr
    nload
    ncdu
    aria
    wget
    unzip
    tpm2-tss
    jq
    yq
    fzf
    tldr
    pass
    parted

    ntfs3g
    gnumake
    cmake
    libgcc
    glibc
    gcc
    gdb
    android-tools

    wireguard-tools
    conntrack-tools
    nftables
    openvpn
    ubridge
    iw

    kubectl
    kubernetes-helm
    k9s
    argocd
    awscli2
    terraform
    ansible
    docker-compose
    podman-compose
    quickemu
    git-crypt
    kind
    k3d
    istioctl
    vscode
    win-virtio
    virt-manager
    vagrant
    krew
    distrobox

    nvme-cli
    stress
    pwgen
    qrencode
    usbutils
    pciutils
    silver-searcher

    nmap
    valgrind
    radare2
    pwntools
    pwndbg
    aircrack-ng
    binwalk

    unstable.poetry
    unstable.winbox

    wl-clipboard
    wineWowPackages.stable
  ];
}

# vim:expandtab ts=2 sw=2
