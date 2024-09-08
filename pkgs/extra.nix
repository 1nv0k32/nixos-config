{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    cryptsetup
    btop
    acpi
    efibootmgr
    nload
    ncdu
    tpm2-tss
    jq
    yq
    tldr
    pass
    parted
    bridge-utils

    chromium
    transmission
    transmission-gtk

    ntfs3g
    unrar-wrapper

    wireguard-tools
    conntrack-tools
    nftables
    openvpn
    ubridge
    iw

    kubernetes-helm
    k9s
    argocd
    awscli2
    terraform
    opentofu
    ansible
    podman-compose
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

    flameshot
    spotify
    obs-studio
    gimp
    vlc
    discord
    vscode
    pkgs-unstable.jetbrains.pycharm-community-bin
    gparted
    rivalcfg
    cobang
    rpi-imager
    yt-dlp
    media-downloader
    tor-browser-bundle-bin
    wineWowPackages.stable
    winetricks

    otpclient
    yubikey-manager
    yubikey-manager-qt

    evince
    gnome-network-displays
    gnome.gnome-terminal
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnome.nautilus
    gnome.file-roller
    gnome.gnome-calculator
    gnome.eog
    gnome.geary
    gnome.gnome-calendar

    gns3-gui
    gns3-server
    dynamips
    inetutils

    stm32cubemx
    stm32loader
    stm32flash

    win-virtio
    virt-manager
    vagrant
    krew
    nixos-generators
    distrobox
    quickemu
    pavucontrol
    networkmanagerapplet
    alsa-utils
    pulseaudio
    android-tools

    nmap
    valgrind
    radare2
    pwntools
    pwndbg
    aircrack-ng
    binwalk
    burpsuite
    ghidra-bin
    pkgs-unstable.proxmark3
  ];

  services.udev.packages = with pkgs; [
    platformio-core
    openocd
    yubikey-personalization
    pkgs-unstable.proxmark3
  ];
}
