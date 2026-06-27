{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    package = pkgs.unstable.steam;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
