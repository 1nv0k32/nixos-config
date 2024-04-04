{ lib, pkgs, config, options, ... }:
with lib;
let
  cfg = config.security.pki;

  certOpts = { name, ... }: {
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
in
{
  options.security.pki.certDER = mkOption {
    default = { };
    type = with types; attrsOf (submodule certOpts);
  };

  config = {
    #security.pki.certificateFiles =
    #  let
    #    cert = pkgs.stdenv.mkDerivation rec {
    #      name = cfg.name;
    #      src = pkgs.fetchurl {
    #        url = cfg.url;
    #        hash = cfg.hash;
    #      };
    #      nativeBuildInputs = [ pkgs.openssl ];
    #      phases = [ "installPhase" ];
    #      installPhase = ''
    #        install -m644 -D $src $out/cert/${name}.der
    #        openssl x509 -inform der -in $out/cert/${name}.der -out $out/cert/${name}.crt
    #      '';
    #    };
    #  in
    #  options.security.pki.certificateFiles.default ++ [ "${cert}/cert/${cfg.name}.crt" ];
  };
}

# vim:expandtab ts=2 sw=2

