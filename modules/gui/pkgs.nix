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
      kitty
      libreoffice
      transmission_4
      transmission_4-gtk
      gparted

      obs-studio
      flameshot
      gimp

      vscode
      jetbrains.clion
      jetbrains.pycharm-community-bin
    ]
    ++ lib.optionals config.environment.sysConf.x86 [
      spotify
      discord
      zoom-us
    ];
}
