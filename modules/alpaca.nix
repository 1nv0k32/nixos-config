{
  lib,
  pkgs,
  config,
  options,
  ...
}:
with lib;
let
  cfg = config.services.alpaca;
in
{
  options.services.alpaca = {
    enable = mkEnableOption "alpaca service";
    ntlmHash = mkOption { type = types.str; };
    pacUrl = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    listenPort = mkOption {
      type = types.str;
      default = "3128";
    };
  };

  config =
    let
      proxy = "http://127.0.0.1:${cfg.listenPort}";
      proxies = {
        no_proxy = "127.0.0.1,localhost";
        ftp_proxy = proxy;
        https_proxy = proxy;
        HTTPS_PROXY = proxy;
        http_proxy = proxy;
        HTTP_PROXY = proxy;
        all_proxy = proxy;
        rsync_proxy = proxy;
      };
      pac_arg = "" + optionalString (cfg.pacUrl != null) "-C ${cfg.pacUrl}";
    in
    mkIf cfg.enable {
      # Setup service
      systemd.services.alpaca = {
        enable = true;
        description = "alpaca proxy service";
        serviceConfig = {
          ExecStart = "${pkgs.pkgs-unstable.alpaca-proxy}/bin/alpaca-proxy -l 0.0.0.0 -p ${cfg.listenPort} ${pac_arg}";
          Restart = "always";
          KillMode = "mixed";
        };
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = {
          NTLM_CREDENTIALS = "${cfg.ntlmHash}";
        };
      };

      environment.systemPackages = [ pkgs.pkgs-unstable.alpaca-proxy ];

      # Set proxy on system and services
      systemd.services = {
        nix-daemon.environment = proxies;
        k3s.environment = proxies;
      };
      networking = {
        proxy.default = mkForce proxy;
      };
    };
}

# vim:expandtab ts=2 sw=2
