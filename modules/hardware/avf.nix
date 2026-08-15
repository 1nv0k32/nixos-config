{
  inputs,
  ...
}:
{
  flake.modules.nixos.hardware-avf = { config, lib, ... }: {
    imports = [
      inputs.nixos-avf.nixosModules.avf
    ];

    users.users."${config.environment.sysConf.user.name}" = {
      initialPassword = lib.mkForce null;
    };

    avf = {
      enableGraphics = false;
      defaultUser = config.environment.sysConf.user.name;
      enableConfigReplace = true;
      vmConfig = {
        memory_mib = lib.mkForce 8192;
      };
    };
  };
}
