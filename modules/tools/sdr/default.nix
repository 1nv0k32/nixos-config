{
  pkgs,
  lib,
  config,
  ...
}:
let
  gui = config.environment.sysConf.gui.enable;
  uhdWrapped = pkgs.symlinkJoin {
    name = "uhd";
    paths = [ pkgs.uhd ];
    postBuild = ''
      cp -r --remove-destination ${./uhd}/* "$out/share/uhd/images"
    '';
  };
in
{
  config = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
    environment.systemPackages =
      with pkgs;
      [
        uhdWrapped
      ]
      ++ lib.optionals gui [
        gnuradio
        gqrx
      ];

    services.udev.packages = with pkgs; [
      uhd
    ];
  };
}
