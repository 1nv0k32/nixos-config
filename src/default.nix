{
  stateVersion,
  modulesPath,
  pkgs,
  lib,
  ...
}:
let
  customConfigs = (import ./configs.nix { inherit modulesPath pkgs lib; });
in
{
  system = {
    stateVersion = stateVersion;
  };

  home-manager.sharedModules = [ (import ../home/base.nix) ];
  home-manager.extraSpecialArgs = {
    inherit stateVersion;
  };

  environment = {
    etc = {
      "inputrc".text = customConfigs.INPUTRC_CONFIG;
      "bashrc.local".text = customConfigs.BASHRC_CONFIG;
    };
  };
}
