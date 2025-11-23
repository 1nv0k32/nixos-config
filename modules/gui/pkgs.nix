{
  config,
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
    ++ lib.optionals config.environment.sysConf.x86 [
      spotify
      discord
      zoom-us
      slack
    ];
}
