{ pkgs, ... }:
{
  shell = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      uv
      python312
    ];

    LD_LIBRARY_PATH =
      with pkgs;
      lib.makeLibraryPath [
        stdenv.cc.cc
        zlib
        zstd
        glib
        libGL
        fontconfig
        dbus
        wayland
        libxkbcommon
        xorg.libX11
        xorg.libxcb
        xorg.libXext
        xorg.xcbutilkeysyms
        xorg.xcbutilwm
        xorg.xcbutilimage
        xorg.xcbutilrenderutil
      ];
  };
}
