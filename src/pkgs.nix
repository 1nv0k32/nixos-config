{
  inputs,
  system,
  config,
  pkgs,
}:
with pkgs;
let
  unstable = import (inputs.nixpkgs-unstable) {
    inherit system;
    inherit config;
  };
in
{
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
    stm32cubemx
    stm32loader
    stm32flash
    burpsuite
    gparted

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
}

# vim:expandtab ts=2 sw=2
