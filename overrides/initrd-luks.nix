{ config, lib, ... }:
with lib;
{
  options.boot.initrd.luks.devices = mkOption {
    type = types.attrsOf (
      types.submodule {
        config.crypttabExtraOpts = mkDefault [
          "tpm2-device=auto"
          "nofail"
        ];
      }
    );
  };
}
