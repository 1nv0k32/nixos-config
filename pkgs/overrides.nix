{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (vagrant.overrideAttrs (oldAttrs: {
      installCheckPhase =
        ''
          export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="0"
        ''
        + oldAttrs.installCheckPhase;
    }))
  ];
}
