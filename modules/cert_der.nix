{ lib, pkgs, config, options, ... }:
with lib;
let
  cfg = config.security.pki;

  certOpts = { name, ... }: {
    url = mkOption {
      type = types.str;
    };
    hash = mkOption {
      type = types.str;
    };
  };
in
{
  options = {
    security.pki.certDER = mkOption {
      default = { };
      type = with types; attrsOf (submodule certOpts);
    };
  };

  config = {
    security.pki.certificateFiles =
      let
        certs = mapAttrs cfg.certDER
          (certName: certOpt:
            pkgs.stdenv.mkDerivation rec {
              name = certName;
              src = pkgs.fetchurl {
                url = certOpt.url;
                hash = certOpt.hash;
              };
              nativeBuildInputs = [ pkgs.openssl ];
              phases = [ "installPhase" ];
              installPhase = ''
                install -m644 -D $src $out/cert/${name}.der
                openssl x509 -inform der -in $out/cert/${name}.der -out $out/cert/${name}.crt
              '';
            }
          );
      in
      options.security.pki.certificateFiles.default ++ [ "${builtins.elemAt certs 0}/cert/rootCore.crt" ];
  };
}

# vim:expandtab ts=2 sw=2

