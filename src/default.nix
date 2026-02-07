{
  self,
  ...
}:
{
  imports = [
    (import ./lib/nix.nix)
  ];

  system = {
    stateVersion = self.nixosModules.stateVersion;
  };

}
