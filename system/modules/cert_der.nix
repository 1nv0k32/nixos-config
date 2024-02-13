{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.security.pki.certDER;
in
{
  options.security.pki.certDER = {
    enable = mkEnableOption "cert DER";
    name = mkOption {
      type = types.str;
    };
    url = mkOption {
      type = types.str;
    };
    hash = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    security.pki.certificateFiles =
      let
        cert = pkgs.stdenv.mkDerivation rec {
          name = cfg.name;
          src = pkgs.fetchurl {
            url = cfg.url;
            hash = cfg.hash;
          };
          nativeBuildInputs = [ pkgs.openssl ];
          phases = [ "installPhase" ];
          installPhase = ''
            install -m644 -D $src $out/cert/${name}.der
            openssl x509 -inform der -in $out/cert/${name}.der -out $out/cert/${name}.crt
          '';
        };
      in
      options.security.pki.certificateFiles ++ [ "${corporateCert}/cert/${cfg.name}.crt" ];
  };
}

