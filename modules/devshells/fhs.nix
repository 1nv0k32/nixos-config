{
  perSystem =
    { pkgs, lib, ... }:
    {
      devShells.fhs = pkgs.buildFHSEnv {
        name = "fhs";
        targetPkgs =
          pkgs:
          (with pkgs; [
            uv
            python312
            libcap
            go
            gcc
            delve
            platformio-core
            openocd
            arduino-cli
            avrdude
            libftdi
            libftdi1
            libusb1
          ]);

        NIX_HARDENING_ENABLE = "";
        LD_LIBRARY_PATH =
          with pkgs;
          lib.makeLibraryPath [
            stdenv.cc.cc
            zlib
          ];

        runScript = ''
          ${lib.getExe pkgs.zsh}
        '';
      };
    };
}
