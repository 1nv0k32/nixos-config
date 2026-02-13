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
      virt-manager
      networkmanagerapplet
      tor-browser

      obs-studio
      flameshot
      gimp

      vscode

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
