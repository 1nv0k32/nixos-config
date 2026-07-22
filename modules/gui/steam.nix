{ pkgs, lib, ... }:
{
  programs.steam = lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
    enable = true;
    package = pkgs.steam;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
