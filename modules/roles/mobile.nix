{ ... }:
{
  flake.modules.nixos.roles-mobile = { ... }: {
    services.fprintd.enable = true;
    services.upower.enable = true;
  };
}
