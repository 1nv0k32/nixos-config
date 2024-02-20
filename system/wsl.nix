{ pkgs, lib, options, config, ... }:
let
  mainUser = config.environment.sysConf.mainUser;
in
with lib;
{
  imports = [
    <nixos-wsl/modules>
  ];

  wsl = {
    enable = true;
    defaultUser = mainUser;
    extraBin = with pkgs; [
      { src = "${coreutils}/bin/uname"; }
    ];
  };
  boot.loader.systemd-boot.enable = mkForce false;

  services = {
    xserver.enable = mkForce false;
    pipewire.enable = mkForce false;
    resolved.enable = mkForce false;
  };

  environment = {
    variables = {
      ORACLE_HOME = "${pkgs.oracle-instantclient.lib}";
      PYTHON_KEYRING_BACKEND = "keyring.backends.fail.Keyring";
    };
    systemPackages = with pkgs; [
      python311
      python312
    ];
  };

  programs = {
    nix-ld.enable = true;
  };

  networking = {
    networkmanager.enable = mkForce false;
    firewall.enable = mkForce false;
  };

  virtualisation.docker.daemon.settings = {
    iptables = false;
    ipv6 = false;
  };
}

# vim:expandtab ts=2 sw=2

