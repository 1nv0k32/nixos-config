{
  pkgs,
  lib,
  ...
}:
{
  flake.modules.nixos.programs-sdr =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      config = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
        environment.systemPackages =
          with pkgs;
          [
            uhd
          ]
          ++ lib.optionals config.environment.sysConf.gui.enable [
            gnuradio
            gqrx
          ];

        services.udev.packages = with pkgs; [
          uhd
        ];
      };
    };
}
