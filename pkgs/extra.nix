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
    appimage-run
    ventoy-full

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
    cilium-cli
    talosctl
    vagrant

    nvme-cli
    stress
    pwgen
    qrencode
    usbutils
    pciutils
    imagemagick
    ghostscript
    ffmpeg
    rivalcfg

    yubikey-manager
    yubioath-flutter

    wineWowPackages.stable
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
    proxmark3
  ];
}
