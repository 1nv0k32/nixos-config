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
          modules = [
            ./hardware-configuration.nix
            ./local.nix
          ];
        };
    in
    {
      nixosConfigurations = builtins.mapAttrs mkHost {
        nyx = cfg.systemTypes.z13g2;
        nyxhub = cfg.systemTypes.hetzner;
        nyxwsl = cfg.systemTypes.wsl;
        # nyxvm = cfg.systemTypes.vm;
        # nyxpi = cfg.systemTypes.rpi5;
      };
    };
}
