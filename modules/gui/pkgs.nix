{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages =
    with pkgs;
    [
      kitty
      flameshot
      wl-clipboard
      grim
      libreoffice
      transmission_4
      transmission_4-gtk
      gparted
      pwvucontrol
      alsa-utils
      virt-manager
      networkmanagerapplet
      obs-studio
      gimp
      freecad
      bruno
      telegram-desktop
      vscode
      opencode-desktop
    ]
    ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
      spotify
      discord
      zoom-us
      slack
      tor-browser
    ];
}
