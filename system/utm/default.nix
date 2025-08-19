{ ... }:
{
  imports = [
    (import ./disko.nix)
  ];

  virtualisation.rosetta.enable = true;
}
