{ pkgs, lib, ... }:
{
  shell = pkgs.mkShell {
    buildInputs = with pkgs; [
      uv
      python312
    ];

    LD_LIBRARY_PATH =
      with pkgs;
      lib.makeLibraryPath [
        stdenv.cc.cc
        zlib
      ];
  };
}
