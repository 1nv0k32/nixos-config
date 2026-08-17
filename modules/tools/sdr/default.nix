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
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      cp -r --remove-destination ${./uhd}/* "$out/share/uhd/images"
      for bin in $out/bin/*; do
        wrapProgram "$bin" \
          --set UHD_IMAGES_DIR "$out/share/uhd/images"
      done
    '';
  };
  guiWrapped = pkgs.symlinkJoin {
    name = "sdrGuiTools";
    paths = with pkgs; [
      gnuradio
      gqrx
      abracadabra
    ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      for bin in $out/bin/*; do
        wrapProgram "$bin" \
          --set UHD_IMAGES_DIR "${uhdWrapped}/share/uhd/images"
      done
    '';
  };
  cliWrapped = pkgs.symlinkJoin {
    name = "sdrCliTools";
    paths = with pkgs; [
      soapysdr-with-plugins
    ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      for bin in $out/bin/*; do
        wrapProgram "$bin" \
          --set UHD_IMAGES_DIR "${uhdWrapped}/share/uhd/images"
      done
    '';
  };
in
{
  config = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
    environment.systemPackages = [
      uhdWrapped
      cliWrapped
    ]
    ++ lib.optionals gui [
      guiWrapped
    ];

    services.udev.packages = with pkgs; [
      uhd
    ];
  };
}
