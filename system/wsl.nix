{ pkgs, lib, options, config, ... }:
with lib;
{
  imports = [
    <nixos-wsl/modules>
  ];

  wsl = {
    enable = true;
    defaultUser = config.environment.sysConf.mainUser;
    extraBin = with pkgs; [
      { src = "${coreutils}/bin/uname"; }
      { src = "${coreutils}/bin/dirname"; }
      { src = "${coreutils}/bin/readlink"; }
      { src = "${coreutils}/bin/cat"; }
      { src = "${wget}/bin/wget"; }
      { src = "${curl}/bin/curl"; }
      { src = "${getconf}/bin/getconf"; }
      { src = "${gnused}/bin/sed"; }
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

