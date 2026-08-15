{ ... }:
{
  flake.modules.nixos.system-printing = { ... }: {
    services.printing.enable = true;
  };
}
