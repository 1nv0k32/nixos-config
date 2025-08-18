{ self, ... }:
{
  imports = [
    (import "${self}/system/vm.nix")
    (import ./disko.nix)
  ];
  virtualisation.rosetta.enable = true;
}
