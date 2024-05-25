{
  inputs = {
    user-config = {
      url = "github:1nv0k32/nixoscfg/main";
    };
  };

  outputs = { user-config, ... }@inputs: {
    nixosConfigurations = {
      "nyx" = user-config.inputs.nixpkgs.lib.nixosSystem {
        system = user-config.outputs.system;
        specialArgs = {
          stateVersion = user-config.outputs.stateVersion;
          hostName = "nyx";
          system = user-config.outputs.system;
          inputs = user-config.inputs;
        };
        modules = user-config.outputs.baseModules ++ [
          (import "${inputs.user-config}/system/z13.nix")
        ];
      };

      "nixos" = user-config.inputs.nixpkgs.lib.nixosSystem {
        system = user-config.outputs.system;
        specialArgs = {
          stateVersion = user-config.outputs.stateVersion;
          hostName = "nixos";
          system = user-config.outputs.system;
          inputs = user-config.inputs;
        };
        modules = user-config.outputs.baseModules ++ [
          (import "${inputs.user-config}/system/wsl.nix")
        ];
      };
    };
  };
}
