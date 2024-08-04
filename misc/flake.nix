{
  inputs = {
    user-config = {
      url = "github:1nv0k32/nixos-config/main";
    };
  };

  outputs =
    { user-config, ... }@inputs:
    let
      baseModules = user-config.baseModules ++ [
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
          specialArgs.hostName = "nyx";
          specialArgs = {
            inherit (user-config) stateVersion system inputs;
          };
          inherit (user-config) system;
          modules = baseModules ++ [ (import "${inputs.user-config}/system/z13.nix") ];
        };

        "wslnix" = user-config.inputs.nixpkgs.lib.nixosSystem {
          specialArgs.hostName = "wslnix";
          specialArgs = {
            inherit (user-config) stateVersion system inputs;
          };
          inherit (user-config) system;
          modules = baseModules ++ [ (import "${inputs.user-config}/system/wsl.nix") ];
        };
      };
    };
}

# vim:expandtab ts=2 sw=2
