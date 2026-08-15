{
  inputs,
  self,
  ...
}:
{
  flake.homeConfigurations.rick = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      self.modules.homeManager.base
      {
        home = {
          username = "rick";
          homeDirectory = "/home/rick";
          stateVersion = self.stateVersion;
        };
      }
    ];
    extraSpecialArgs = {
      stateVersion = self.stateVersion;
      gui = { enable = false; };
    };
  };
}
