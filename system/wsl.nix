{
  lib,
  pkgs,
  config,
  ...
}:
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

  environment.variables.VAGRANT_WSL_ENABLE_WINDOWS_ACCESS = lib.mkForce "0";
  services.resolved.enable = lib.mkForce false;
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    initrd.systemd.enable = lib.mkForce false;
    binfmt.emulatedSystems = lib.mkForce [ ];
  };
}
