{
  inputs = {
    user-config = {
      url = "github:1nv0k32/nixoscfg/main";
    };
  };

  outputs =
    { user-config, ... }@inputs:
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
            user-config.baseModules
            ++ user-config.localModules
            ++ [ (import "${inputs.user-config}/system/z13.nix") ];
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
            user-config.baseModules
            ++ user-config.localModules
            ++ [ (import "${inputs.user-config}/system/wsl.nix") ];
        };
      };
    };
}
