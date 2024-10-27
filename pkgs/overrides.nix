{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (vagrant.overrideAttrs (oldAttrs: {
      installCheckPhase =
        ''
          export VAGRANT_WSL_DISABLE_WINDOWS_ACCESS=
        ''
        + oldAttrs.installCheckPhase;
    }))
  ];
}
