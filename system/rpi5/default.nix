{
  lib,
  pkgs,
  ...
}:
{
  # imports = [
  # (import ./disko.nix)
  # ];

  users.users.root.initialPassword = "root";

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxKernel.packages.linux_rpi4;
    kernelParams = [
      "cgroup_enable=memory"
      "cgroup_enable=cpuset"
      "cgroup_memory=1"
    ];
    loader = {
      systemd-boot.enable = false;
      generic-extlinux-compatible.enable = true;
    };
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
}
