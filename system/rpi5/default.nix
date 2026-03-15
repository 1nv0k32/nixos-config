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
  networking = {
    useDHCP = lib.mkForce false;
    firewall.enable = lib.mkForce false;
  };

  boot = {
    loader.raspberry-pi.bootloader = "kernel";
    kernelParams = [
      "cgroup_enable=cpuset"
      "cgroup_enable=memory"
      "cgroup_memory=1"
    ];
  };

  hardware.raspberry-pi.config.all = {
    base-dt-params = {
      pciex1 = {
        enable = true;
      };
      pciex1_gen = {
        enable = true;
        value = 3;
      };
    };
  };
}
