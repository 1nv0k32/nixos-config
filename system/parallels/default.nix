{ ... }:
{
  imports = [
    (import ./disko.nix)
  ];

  hardware.parallels.enable = true;
}
