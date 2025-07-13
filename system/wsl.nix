{
  lib,
  config,
  pkgs,
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
    extraBin = with pkgs; [
      { src = "${wget}/bin/wget"; }
      { src = "${curl}/bin/curl"; }
    ];
    wslConf = {
      user.default = cfg.user.name;
      boot.systemd = true;
    };
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libgcc
      zlib
    ];
  };

  services.resolved.enable = lib.mkForce false;
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    initrd.systemd.enable = lib.mkForce false;
    binfmt.emulatedSystems = lib.mkForce [ ];
  };
}
