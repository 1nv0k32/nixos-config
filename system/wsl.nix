{ pkgs, lib, options, ... }:
with lib;
{
  imports = [
    <nixos-wsl/modules>
  ];

  wsl = {
    enable = true;
    defaultUser = "rick";
  };

  home-manager.users."rick".programs.git = {
    userName = mkDefault "Name";
    userEmail = mkDefault "Name@domain.local";
  };

  services = {
    xserver.enable = mkForce false;
  };

  systemd.services = {
    systemd-resolved.enable = mkForce false;
  };

  boot.loader.systemd-boot.enable = mkForce false;
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

