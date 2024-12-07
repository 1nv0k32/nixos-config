{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cryptsetup
    btop
    acpi
    efibootmgr
    nload
    ncdu
    tpm2-tss
    tldr
    pass
    parted
    bridge-utils
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
    talosctl

    nvme-cli
    stress
    pwgen
    qrencode
    usbutils
    pciutils
    imagemagick
    ghostscript
    ffmpeg

    transmission_4
    transmission_4-gtk
    flameshot
    spotify
    obs-studio
    gimp
    discord
    pkgs-master.vscode
    pkgs-unstable.jetbrains.pycharm-community-bin
    gparted
    rivalcfg
    tor-browser-bundle-bin
    wineWowPackages.stable
    winetricks

    otpclient
    yubikey-manager
    yubikey-manager-qt

    win-virtio
    virt-manager
    nixos-generators
    distrobox
    quickemu
    pavucontrol
    networkmanagerapplet
    android-tools

    nmap
    radare2
    pwntools
    pwndbg
    aircrack-ng
    binwalk
    burpsuite
    ghidra-bin
    proxmark3
  ];

  services.udev.packages = with pkgs; [
    platformio-core
    openocd
    yubikey-personalization
    pkgs-unstable.proxmark3
  ];
}
