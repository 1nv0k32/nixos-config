{ ... }:
{
  flake.modules.nixos.system-fwupd = { ... }: {
    services.fwupd.enable = true;
  };
}
