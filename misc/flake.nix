{
  inputs = {
    user-config = {
      url = "github:1nv0k32/nixoscfg/dev";
    };
  };

  outputs =
    { user-config, ... }@inputs:
    let
      localModules = [
        (
          { lib, ... }:
          {
            imports =
              [ ]
              ++ lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix
              ++ lib.optional (builtins.pathExists ./local.nix) ./local.nix;
          }
        )
      ];
    in
    {
      nixosConfigurations = {
        "nyx" = user-config.inputs.nixpkgs.lib.nixosSystem {
          system = user-config.system;
          specialArgs = {
            stateVersion = user-config.stateVersion;
            hostName = "nyx";
            system = user-config.system;
            inputs = user-config.inputs;
          };
          modules =
            user-config.baseModules ++ localModules ++ [ (import "${inputs.user-config}/system/z13.nix") ];
        };

        "nixos" = user-config.inputs.nixpkgs.lib.nixosSystem {
          system = user-config.system;
          specialArgs = {
            stateVersion = user-config.stateVersion;
            hostName = "nixos";
            system = user-config.system;
            inputs = user-config.inputs;
          };
          modules =
            user-config.baseModules ++ localModules ++ [ (import "${inputs.user-config}/system/wsl.nix") ];
        };
      };
    };
}
