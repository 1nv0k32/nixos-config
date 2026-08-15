{
  inputs,
  self,
  ...
}:
{
  flake.darwinConfigurations.nyxdarwin = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = {
      inherit self;
      stateVersion = self.stateVersion;
    };
    modules = [
      self.modules.darwin."host-nyxdarwin"
    ];
  };
}
