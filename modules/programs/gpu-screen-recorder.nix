{
  pkgs,
  ...
}:
{
  flake.modules.nixos.programs-gpu-screen-recorder = { pkgs, ... }: {
    programs.gpu-screen-recorder.enable = true;

    environment.systemPackages = with pkgs; [
      gpu-screen-recorder-gtk
    ];
  };
}
