{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages =
    with pkgs;
    [
      #bitwarden-desktop
      #kitty
      #libreoffice
      #transmission_4
      #transmission_4-gtk
      gparted
      pwvucontrol
      alsa-utils
      virt-manager
      networkmanagerapplet
      tor-browser
      solaar

      obs-studio
      flameshot
      gimp
      freecad
      orca-slicer

      vscode

      telegram-desktop
    ]
    ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
      spotify
      discord
      zoom-us
      slack
    ];
}
