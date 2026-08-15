{ ... }:
{
  flake.modules.nixos.programs-localsend = { ... }: {
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  };
}
