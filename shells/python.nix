{ pkgs, ... }:
{
  shell = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      uv
      python312
      urh
    ];

    LD_LIBRARY_PATH =
      with pkgs;
      lib.makeLibraryPath [
        stdenv.cc.cc
        zlib
        zstd
      ];
  };
}
