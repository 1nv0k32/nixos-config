{ lib, pkgs, ... }:
{
  # imports = [
  #   (import ../modules/media.nix)
  #   (import ../modules/k3s.nix)
  #   (import ../modules/gitea.nix)
  # ];

  users.users.root.initialPassword = "root";

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    kernelParams = [
      "cgroup_enable=memory"
      "cgroup_enable=cpuset"
      "cgroup_memory=1"
    ];
  };
  hardware = {
    bluetooth.enable = true;
  };

  networking = {
    firewall.enable = lib.mkForce false;
    useDHCP = false;
    interfaces = {
      wlan0.useDHCP = true;
      eth0.useDHCP = true;
    };
  };

  services = {
    openssh.enable = true;
  };
}
