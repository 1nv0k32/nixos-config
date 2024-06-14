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
in
{
  environment.systemPackages = with pkgs; [
    vscode
    gparted
    firefox
    spotify
    flameshot
    otpclient
    vlc
    gimp
    discord
    rivalcfg
    cobang
    rpi-imager
    yt-dlp
    media-downloader
    unstable.winbox

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
    unstable.proxmark3
  ];
}

# vim:expandtab ts=2 sw=2
