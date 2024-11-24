{ lib, ... }:
{
  imports = [
    (import ../modules/media.nix)
    (import ../modules/k3s.nix)
    (import ../modules/gitea.nix)
  ];

  users.users.root.initialPassword = "root";

  boot.kernelParams = [
    "cgroup_enable=memory"
    "cgroup_enable=cpuset"
    "cgroup_memory=1"
  ];
  raspberry-pi-nix.board = "bcm2712";
  hardware = {
    bluetooth.enable = true;
    raspberry-pi = {
      config.all.base-dt-params = {
        krnbt = {
          enable = true;
          value = "on";
        };
      };
    };
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
