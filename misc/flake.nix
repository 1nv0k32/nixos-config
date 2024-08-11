{
  inputs = {
    user-config = {
      url = "github:1nv0k32/nixos-config/main";
    };
  };

  outputs =
    { user-config, ... }@inputs:
    let
      baseModules = [
        (
          { lib, ... }:
          {
            imports =
              [ ]
              ++ lib.optional (builtins.pathExists ./hardware-configuration.nix) (import ./hardware-configuration.nix)
              ++ lib.optional (builtins.pathExists ./local.nix) (import ./local.nix);
          }
        )
      ];
    in
    {
      nixosConfigurations = {
        "nyx" = user-config.inputs.nixpkgs.lib.nixosSystem user-config.systemTypes.z13g2 // {
          specialArgs.hostName = "nyx";
          # modules = baseModules;
        };
      };
    };
}
