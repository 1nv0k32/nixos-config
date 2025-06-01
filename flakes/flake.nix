{
  inputs = {
    cfg = {
      url = "github:1nv0k32/nixos-config";
    };
  };

  outputs =
    { cfg, ... }:
    let
      mkHost =
        host: systemType:
        systemType {
          hostName = host;
          modules = cfg.optionalLocalModules [
            ./hardware-configuration.nix
            ./local.nix
          ];
        };
    in
    {
      nixosConfigurations = builtins.mapAttrs mkHost {
        nyx = cfg.systemTypes.z13g2;
        nyxvm = cfg.systemTypes.vm;
        nyxwsl = cfg.systemTypes.wsl;
        nyxpi = cfg.systemTypes.rpi5;
        hub = cfg.systemTypes.hetzner;
      };
    };
}
