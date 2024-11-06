{
  stateVersion,
  modulesPath,
  lib,
  ...
}:
let
  customConfigs = (import ./configs.nix { inherit modulesPath lib; });
in
{
  system = {
    stateVersion = stateVersion;
  };

  home-manager = {
    sharedModules = [ (import ../home/base.nix) ];
    extraSpecialArgs = {
      inherit stateVersion;
    };
  };

  environment = {
    etc = {
      "inputrc".text = customConfigs.INPUTRC_CONFIG;
    };
  };
}
