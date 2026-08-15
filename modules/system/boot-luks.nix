{
  lib,
  ...
}:
{
  flake.modules.nixos.system-boot-luks = { lib, ... }: {
    options.boot.initrd.luks.devices = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          config.crypttabExtraOpts = lib.mkDefault [
            "tpm2-device=auto"
            "fido2-device=auto"
            "nofail"
          ];
        }
      );
    };
  };
}
