{
  inputs,
  self,
  ...
}:
{
  flake.darwinConfigurations.nyxdarwin = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = {
      inherit inputs self;
      stateVersion = self.lib.stateVersion;
    };
    modules = [
      self.modules.darwin."host-nyxdarwin"
    ];
  };
}
