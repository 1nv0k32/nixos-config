{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libreoffice
    flameshot
    gimp
    transmission_4
    transmission_4-gtk

    pkgs-master.vscode
    pkgs-unstable.jetbrains.pycharm-community-bin

    spotify
    discord
    zoom-us
    obs-studio

    gparted
    tor-browser-bundle-bin
  ];
}
