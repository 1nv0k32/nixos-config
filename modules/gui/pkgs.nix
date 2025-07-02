{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty
    libreoffice
    flameshot
    gimp
    transmission_4
    transmission_4-gtk

    # spotify
    # discord
    # zoom-us
    # obs-studio

    # gparted
    # tor-browser-bundle-bin

    vscode
    jetbrains.clion
    jetbrains.pycharm-community-bin
  ];
}
