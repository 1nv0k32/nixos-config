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

    kubernetes-helm
    k9s
    argocd
    opentofu
    podman-compose
    kind
    k3d
    istioctl
    cilium-cli
    talosctl
    openstackclient-full

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

    distrobox
    quickemu
    android-tools

    nmap
    radare2
    binwalk

    platformio-core
    openocd
    proxmark3
  ];

  services.udev.packages = with pkgs; [
    platformio-core.udev
    openocd
    proxmark3
  ];
}
