{ ... }:
{
  imports = [
    (import ./disko.nix)
  ];

  boot = {
    growPartition = true;
  };

  hardware.parallels.enable = true;
}
