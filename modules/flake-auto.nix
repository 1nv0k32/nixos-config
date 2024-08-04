{ pkgs, config, ... }:
{
  systemd.services.flake-auto = {
    enable = true;
    description = "Service for flake automation";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "flake-auto-sh" ''
        FLAKE_URL="https://raw.githubusercontent.com/1nv0k32/nixos-config/main/misc/flake.nix"
        FLAKE_PATH=/etc/nixos/flake.nix
        ${pkgs.curl}/bin/curl -s $FLAKE_URL -o $FLAKE_PATH
        exit 0

        ### ${config.system.path} ###
      ''}";
    };
  };
}

# vim:expandtab ts=2 sw=2
