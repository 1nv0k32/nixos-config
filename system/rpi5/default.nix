{
  self,
  lib,
  ...
}:
{
  imports = [
    (import ./disko.nix)
    (import "${self}/modules/etc/media.nix")
    (import "${self}/modules/etc/gitea.nix")
  ];

  users.users.root.initialPassword = "root";
  systemd.network.enable = true;
  networking.useDHCP = lib.mkForce false;
  networking.firewall.enable = lib.mkForce false;

  boot = {
    loader.raspberry-pi.bootloader = "kernel";
    kernelParams = [
      "cgroup_enable=cpuset"
      "cgroup_memory=1"
      "cgroup_enable=memory"
    ];
  };
}
