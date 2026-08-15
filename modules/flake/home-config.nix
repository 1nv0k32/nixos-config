{
  inputs,
  self,
  ...
}:
{
  flake.homeConfigurations.rick = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    extraSpecialArgs = {
      stateVersion = self.lib.stateVersion;
      gui = { enable = false; };
    };
    modules = [
      self.modules.homeManager.base
      self.modules.homeManager.dconf
      self.modules.homeManager.terminal
      {
        home = {
          username = "rick";
          homeDirectory = "/home/rick";
        };
      }
    ];
  };
}
