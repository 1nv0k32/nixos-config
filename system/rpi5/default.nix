{
  self,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (import ./disko.nix)
    (import "${self}/modules/media.nix")
    (import "${self}/modules/k3s.nix")
    (import "${self}/modules/gitea.nix")
  ];

  users.users.root.initialPassword = "root";

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxKernel.packages.linux_rpi4;
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
}
