{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libreoffice
    flameshot
    gimp
    transmission_4
    transmission_4-gtk

    vscode

    spotify
    discord
    zoom-us
    obs-studio

    gparted
    tor-browser-bundle-bin
  ];
}
