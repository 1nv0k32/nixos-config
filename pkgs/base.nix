{
  inputs,
  system,
  pkgs,
  config,
  ...
}:
let
  unstable = import (inputs.nixpkgs-unstable) {
    config = config.nixpkgs.config;
    inherit system;
  };
  old = import (inputs.nixpkgs-old) {
    config = config.nixpkgs.config;
    inherit system;
  };
in
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

    unstable.poetry
    old.hatch

    wl-clipboard
    wineWowPackages.stable
  ];
}

# vim:expandtab ts=2 sw=2
