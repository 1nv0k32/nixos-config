{
  inputs = {
    user-config = {
      url = "github:1nv0k32/nixoscfg/main";
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
              ++ lib.optional (builtins.pathExists ./hardware-configuration.nix) (import ./hardware-configuration.nix)
              ++ lib.optional (builtins.pathExists ./local.nix) (import ./local.nix);
          }
        )
      ];
    in
    {
      nixosConfigurations = {
        "nyx" = user-config.inputs.nixpkgs.lib.nixosSystem {
          system = user-config.system;
          specialArgs = {
            hostName = "nyx";
            stateVersion = user-config.stateVersion;
            system = user-config.system;
            inputs = user-config.inputs;
          };
          modules =
            user-config.baseModules ++ localModules ++ [ (import "${inputs.user-config}/system/z13.nix") ];
        };

        "vmnyx" = user-config.inputs.nixpkgs.lib.nixosSystem {
          system = user-config.system;
          specialArgs = {
            hostName = "vmnyx";
            stateVersion = user-config.stateVersion;
            system = user-config.system;
            inputs = user-config.inputs;
          };
          modules =
            user-config.baseModules ++ localModules ++ [ (import "${inputs.user-config}/system/vm.nix") ];
        };

        "nixos" = user-config.inputs.nixpkgs.lib.nixosSystem {
          system = user-config.system;
          specialArgs = {
            hostName = "nixos";
            stateVersion = user-config.stateVersion;
            system = user-config.system;
            inputs = user-config.inputs;
          };
          modules =
            user-config.baseModules ++ localModules ++ [ (import "${inputs.user-config}/system/wsl.nix") ];
        };
      };
    };
}
