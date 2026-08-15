{ ... }:
{
  flake.modules.nixos.system-hardware = { ... }: {
    hardware = {
      enableAllFirmware = true;
      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
      wirelessRegulatoryDatabase = true;
    };
  };
}
