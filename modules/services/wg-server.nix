{
  lib,
  config,
  ...
}:
{
  flake.modules.nixos.services-wg-server = { lib, config, ... }: {
    options.environment.sysConf = {
      server.wg = {
        enable = lib.mkEnableOption "server.wg";

        interface = lib.mkOption {
          type = lib.types.str;
          default = "wg0";
        };

        ip = lib.mkOption {
          type = lib.types.str;
          default = "10.100.0.1/24";
        };

        port = lib.mkOption {
          type = lib.types.int;
          default = 51820;
        };

        privateKeyFile = lib.mkOption {
          type = lib.types.str;
          default = "";
        };

        peers = lib.mkOption {
          type = lib.types.listOf lib.types.attrs;
          default = [
            {
              PublicKey = "";
              AllowedIPs = [ "10.100.0.2/32" ];
            }
          ];
        };
      };
    };

    config = lib.mkIf config.environment.sysConf.server.wg.enable {
      networking.firewall.allowedUDPPorts = [ config.environment.sysConf.server.wg.port ];

      systemd.network = {
        enable = true;

        netdevs."50-${config.environment.sysConf.server.wg.interface}" = {
          netdevConfig = {
            Name = config.environment.sysConf.server.wg.interface;
            Kind = "wireguard";
            MTUBytes = "1440";
          };
          wireguardConfig = {
            ListenPort = config.environment.sysConf.server.wg.port;
            PrivateKeyFile = config.environment.sysConf.server.wg.privateKeyFile;
            RouteTable = "main";
          };
          wireguardPeers = config.environment.sysConf.server.wg.peers;
        };

        networks.${config.environment.sysConf.server.wg.interface} = {
          matchConfig.Name = config.environment.sysConf.server.wg.interface;
          address = [ config.environment.sysConf.server.wg.ip ];
          networkConfig = {
            IPMasquerade = "ipv4";
            IPv4Forwarding = true;
          };
        };
      };
    };
  };
}
