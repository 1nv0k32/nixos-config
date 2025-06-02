{
  lib,
  config,
  ...
}:
let
  cfg = config.environment.sysConf;
in
{
  wsl = {
    enable = true;
    startMenuLaunchers = true;
    defaultUser = cfg.user.name;
  };

  programs.nix-ld = {
    enable = true;
  };

  services.resolved.enable = lib.mkForce false;
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    initrd.systemd.enable = lib.mkForce false;
    binfmt.emulatedSystems = lib.mkForce [ ];
  };
}
