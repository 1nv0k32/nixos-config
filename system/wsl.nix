{ lib, config, ... }:
{
  wsl = {
    enable = true;
    startMenuLaunchers = true;
    defaultUser = config.environment.sysConf.mainUser;
  };

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };

  services.resolved.enable = lib.mkForce false;
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    initrd.systemd.enable = lib.mkForce false;
    binfmt.emulatedSystems = lib.mkForce [ ];
  };
}
