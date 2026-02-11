{
  self,
  ...
}:
{
  imports = [
    (import ./disko.nix)
    (import "${self}/modules/etc/media.nix")
    (import "${self}/modules/etc/k3s.nix")
    (import "${self}/modules/etc/gitea.nix")
  ];

  users.users.root.initialPassword = "root";

  boot.loader.raspberry-pi.bootloader = "kernel";

  systemd.network.enable = true;

  boot.kernelParams = [
    "cgroup_enable=cpuset"
    "cgroup_memory=1"
    "cgroup_enable=memory"
  ];
}
