{
  inputs = {
    user-config = {
      url = "github:1nv0k32/nixoscfg/main";
    };
  };

  outputs = { user-config, ... }@inputs:
    let
      baseModules = [
        (
          { lib, ... }: {
            imports = [ ]
              ++ lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix
              ++ lib.optional (builtins.pathExists ./local.nix) ./local.nix;
          }
        )
        (import "${inputs.user-config}/src")
        (import "${inputs.user-config}/modules")
      ];
    in
    {
      nixosConfigurations = {
        "nyx" = user-config.inputs.nixpkgs.lib.nixosSystem {
          system = user-config.outputs.system;
          specialArgs = {
            stateVersion = user-config.outputs.stateVersion;
            hostName = "nyx";
            inputs = user-config.inputs;
          };
          modules = baseModules ++ [
            (import "${inputs.user-config}/system/z13.nix")
          ];
        };

        "nixos" = user-config.inputs.nixpkgs.lib.nixosSystem {
          system = user-config.outputs.system;
          specialArgs = {
            stateVersion = user-config.outputs.stateVersion;
            hostName = "nixos";
            inputs = user-config.inputs;
          };
          modules = baseModules ++ [
            (import "${inputs.user-config}/system/wsl.nix")
          ];
        };
      };
    };
}
