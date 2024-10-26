{ lib, config, ... }:
{
  wsl = {
    enable = true;
    startMenuLaunchers = true;
    defaultUser = config.environment.sysConf.mainUser;
  };

  services.resolved.enable = lib.mkForce false;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.initrd.systemd.enable = lib.mkForce false;
  boot.binfmt.emulatedSystems = lib.mkForce [ ];
}
