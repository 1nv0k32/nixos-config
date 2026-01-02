{ pkgs, ... }:
{
  shell = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      # python
      uv
      python312
      # go
      libcap
      go
      gcc
      delve
      # platformio
      platformio-core
      openocd
      arduino-cli
      avrdude
      libftdi
      libftdi1
      libusb1
    ];

    NIX_HARDENING_ENABLE = "";
    LD_LIBRARY_PATH =
      with pkgs;
      lib.makeLibraryPath [
        stdenv.cc.cc
        zlib
      ];
  };
}
