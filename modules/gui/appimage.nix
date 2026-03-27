{ pkgs, ... }:
{
  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
  ];
  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [
        pkgs.libsoup_2_4
        pkgs.webkitgtk
      ];
    };
  };
}
