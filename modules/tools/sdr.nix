{
  pkgs,
  lib,
  config,
  ...
}:
let
  gui = config.environment.sysConf.gui.enable;
in
{
  config = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
    environment.systemPackages =
      with pkgs;
      [
        uhd
      ]
      ++ lib.optionals gui [
        gqrx
      ];

    services.udev.packages = with pkgs; [
      uhd
    ];
  };
}
