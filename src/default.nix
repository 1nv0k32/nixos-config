{
  stateVersion,
  modulesPath,
  pkgs,
  lib,
  ...
}:
let
in
# customConfigs = (import ./configs.nix { inherit modulesPath pkgs lib; });
{
  system = {
    stateVersion = stateVersion;
  };

  home-manager.sharedModules = [ (import ../home/base.nix) ];
  home-manager.extraSpecialArgs = {
    inherit stateVersion;
  };

  # environment = {
  #   etc = {
  #     "inputrc".text = customConfigs.INPUTRC_CONFIG;
  #     "bashrc.local".text = customConfigs.BASHRC_CONFIG;
  #   };
  # };
}
