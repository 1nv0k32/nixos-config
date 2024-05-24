{ inputs, config, pkgs }:
with pkgs;
let
  unstable = import (inputs.nixpkgs-unstable) { config = config.nixpkgs.config; };
in
{
  CONSOLE = [
    terminus_font
  ];

  FONT = [
    ubuntu_font_family
    vazir-fonts
  ];

  USER = [
    chromium
    firefox
    spotify
    flameshot
    otpclient
    gns3-gui
    gns3-server
    dynamips
    inetutils
    pavucontrol
    networkmanagerapplet
    imagemagick
    ghostscript
    ffmpeg
    vlc
    gimp
    evince
    rivalcfg
    discord
    transmission
    transmission-gtk
    pulseaudio
    unrar-wrapper
    cobang
    alsa-utils
    ghidra-bin
    rpi-imager
    yt-dlp
    media-downloader
    pass

    gnome.gnome-terminal
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnome.nautilus
    gnome.file-roller
    gnome.gnome-calculator
    gnome.eog
    gnome.geary
    gnome.gnome-calendar
  ];

  GNOME_EXT = [
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
    gnomeExtensions.tiling-assistant
    gnomeExtensions.caffeine
    gnomeExtensions.unblank
  ];

  SYSTEM = [
    niv
    nixos-generators
    cryptsetup
    openssl
    git
    tmux
    bat
    nixpkgs-fmt
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

    ntfs3g
    gnumake
    cmake
    libgcc
    glibc
    gcc
    gdb
    valgrind
    android-tools

    wireguard-tools
    conntrack-tools
    nftables
    openvpn
    ubridge
    iw

    kubectl
    kubernetes-helm
    krew
    k9s
    argocd
    awscli2
    vscode
    virt-manager
    win-virtio
    vagrant
    terraform
    ansible
    docker-compose
    podman-compose
    distrobox
    quickemu
    git-crypt
    kind
    k3d
    istioctl

    nvme-cli
    gparted
    stress
    pwgen
    qrencode
    usbutils
    pciutils
    silver-searcher

    nmap
    burpsuite
    radare2
    pwntools
    pwndbg
    aircrack-ng
    binwalk

    unstable.poetry

    stm32cubemx
    stm32loader
    stm32flash

    wl-clipboard
    wineWowPackages.stable
  ];
}

# vim:expandtab ts=2 sw=2
