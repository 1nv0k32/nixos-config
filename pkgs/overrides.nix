{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (vagrant.overrideAttrs (oldAttrs: {
      installCheckPhase = "";
    }))
  ];
}
