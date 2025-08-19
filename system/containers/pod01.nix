{ self, ... }:
{
  imports = [ ];

  system = {
    stateVersion = self.nixosModules.stateVersion;
  };
}
