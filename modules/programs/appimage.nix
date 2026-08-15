{ ... }:
{
  flake.modules.nixos.programs-appimage = { ... }: {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
