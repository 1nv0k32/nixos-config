{ ... }:
{
  flake.modules.nixos.system-time = { ... }: {
    time = {
      timeZone = "CET";
      hardwareClockInLocalTime = false;
    };
  };
}
