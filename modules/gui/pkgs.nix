{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty
    libreoffice
    transmission_4
    transmission_4-gtk
    gparted

    spotify
    discord
    zoom-us
    obs-studio
    flameshot
    gimp

    vscode
    jetbrains.clion
    jetbrains.pycharm-community-bin
  ];
}
