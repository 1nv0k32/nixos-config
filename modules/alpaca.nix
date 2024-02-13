{ lib, pkgs, config, options, ... }:
with lib;
let
  cfg = config.services.alpaca;
in
{
  options.services.alpaca = {
    enable = mkEnableOption "alpaca service";
    #pacUrl = mkOption {
    #  type = types.nullOr types.str;
    #  default = null;
    #};
    ntlmHash = mkOption {
      type = types.str;
    };
    listenAddr = {
      type = types.str;
      default = "0.0.0.0";
    };
    listenPort = {
      type = types.str;
      default = "3128";
    };
  };

  config =
    let
      proxy = "http://${cfg.listenAddr}:${cfg.listenPort}";
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
      alpaca = pkgs.stdenv.mkDerivation rec {
        pname = "alpaca";
        version = "2.0.3";
        src = pkgs.fetchurl {
          url = "https://github.com/samuong/alpaca/releases/download/v${version}/alpaca_v${version}_linux-amd64";
          sha256 = "HFT6URkSOtJLKcCRs/epHFeLgZxVh5YEYJJtl74MokM=";
        };
        nativeBuildInputs = [ pkgs.autoPatchelfHook ];
        phases = [ "installPhase" ];
        installPhase = ''
          install -m755 -D $src $out/bin/${pname}
          autoPatchelf $out/bin/${pname}
        '';
      };
      #pac_arg = "" + optionalString (cfg.pacUrl != null) "-C ${cfg.pacUrl}";
    in
    mkIf cfg.enable {
      # Setup service
      systemd.services."alpaca" = {
        enable = true;
        description = "alpaca proxy service";
        serviceConfig = {
          ExecStart = "${alpaca}/bin/alpaca -l ${cfg.listenAddr} -p ${cfg.listenPort}";
          Restart = "always";
          KillMode = "mixed";
        };
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = {
          NTLM_CREDENTIALS = "${cfg.ntlmHash}";
        };
      };

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

