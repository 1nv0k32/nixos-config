{ pkgs, ... }:
{
  systemd.services.systemd-legacy-cgroup = {
    enable = true;
    description = "Service to mount systemd legacy cgroup";
    wantedBy = [ "basic.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "systemd-legacy-cgroup-sh" ''
        if ! ${pkgs.mount}/bin/mount | ${pkgs.gnugrep}/bin/grep -q cgroup/systemd; then
          ${pkgs.coreutils}/bin/mkdir -p /sys/fs/cgroup/systemd
          ${pkgs.mount}/bin/mount -t cgroup cgroup -o none,name=systemd /sys/fs/cgroup/systemd
        fi
        exit 0
      ''}";
    };
  };
}

# vim:expandtab ts=2 sw=2
