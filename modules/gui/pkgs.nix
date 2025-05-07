{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty
    libreoffice
    flameshot
    gimp
    transmission_4
    transmission_4-gtk

    vscode
    pkgs-unstable.jetbrains.clion

    spotify
    discord
    zoom-us
    obs-studio

    gparted
    tor-browser-bundle-bin
  ];
}
