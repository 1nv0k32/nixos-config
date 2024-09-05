{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
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
    bridge-utils

    chromium
    transmission
    transmission-gtk

    ntfs3g
    gnumake
    cmake
    libgcc
    glibc
    gcc
    gdb
    unrar-wrapper

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
    opentofu
    ansible
    docker-compose
    podman-compose
    git-crypt
    kind
    k3d
    istioctl

    nvme-cli
    stress
    pwgen
    qrencode
    usbutils
    pciutils
    silver-searcher
    imagemagick
    ghostscript
    ffmpeg

    pkgs-unstable.uv
    python312
  ];
}
