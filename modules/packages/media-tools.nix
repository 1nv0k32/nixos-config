{
  pkgs,
  ...
}:
{
  flake.modules.nixos.packages-media-tools = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      imagemagick
      ghostscript
      ffmpeg
      rivalcfg
    ];
  };
}
