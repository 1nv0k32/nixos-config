{ inputs, pkgs, ... }:
with pkgs;
let
  unstable = import (inputs.nixpkgs-unstable) { config = config.nixpkgs.config; };
in
{
  userPkgs = [
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
}

# vim:expandtab ts=2 sw=2
