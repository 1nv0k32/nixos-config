{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (vagrant.overrideAttrs (oldAttrs: {
      installCheckPhase =
        ''
          export VAGRANT_WSL_ACCESS_WINDOWS_USER="0"
        ''
        + oldAttrs.installCheckPhase;
    }))
  ];
}
