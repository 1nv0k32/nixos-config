{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages =
    with pkgs;
    [
      bitwarden-desktop
      kitty
      libreoffice
      transmission_4
      transmission_4-gtk
      gparted
      pavucontrol
      alsa-utils
      alsa-ucm-conf
      virt-manager
      networkmanagerapplet

      obs-studio
      flameshot
      gimp

      vscode
      jetbrains.clion
      jetbrains.pycharm-community-bin

      telegram-desktop

      burpsuite
    ]
    ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
      spotify
      discord
      zoom-us
      slack
    ];
}
