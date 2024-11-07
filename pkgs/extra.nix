{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    nixd
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
    ansible-lint
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
    imagemagick
    ghostscript
    ffmpeg

    flameshot
    spotify
    obs-studio
    gimp
    discord
    pkgs-master.vscode
    pkgs-unstable.jetbrains.pycharm-community-bin
    gparted
    rivalcfg
    cobang
    tor-browser-bundle-bin
    wineWowPackages.stable
    winetricks

    otpclient
    yubikey-manager
    yubikey-manager-qt

    stm32cubemx
    stm32loader
    stm32flash

    win-virtio
    virt-manager
    krew
    nixos-generators
    distrobox
    quickemu
    pavucontrol
    networkmanagerapplet
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

    pkgs-master.uv
    python312
  ];

  services.udev.packages = with pkgs; [
    platformio-core
    openocd
    yubikey-personalization
    pkgs-unstable.proxmark3
  ];
}
