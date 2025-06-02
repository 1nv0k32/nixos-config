{ lib, config, ... }:
let
  cfg = config.environment.sysConf.wg;
in
{
  options.environment.sysConf.wg = {
    interface = lib.mkOption {
      type = lib.types.str;
      default = "wg0";
    };

    ip = lib.mkOption {
      type = lib.types.str;
      default = 51820;
    };

    port = lib.mkOption {
      type = lib.types.str;
      default = 51820;
    };
  };

  config = {
    networking.firewall.allowedUDPPorts = [ cfg.port ];
    systemd.network = {
      enable = true;
      netdevs."50-${cfg.interface}" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = cfg.interface;
          MTUBytes = "1300";
        };
        wireguardConfig = {
          PrivateKeyFile = "/run/keys/wireguard-privkey";
          ListenPort = cfg.port;
          RouteTable = "main";
        };
        wireguardPeers = [
          {
            PublicKey = "L4msD0mEG2ctKDtaMJW2y3cs1fT2LBRVV7iVlWZ2nZc=";
            AllowedIPs = [ "10.100.0.2" ];
          }
        ];
      };
      networks.${cfg.interface} = {
        matchConfig.Name = cfg.interface;
        address = [ "10.100.0.1/24" ];
        networkConfig = {
          IPMasquerade = "ipv4";
          IPForward = true;
        };
      };
    };
  };
}
