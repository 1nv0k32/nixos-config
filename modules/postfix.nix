{ config, lib, ... }:
{
  services.postfix = lib.mkIf (config.environment.sysConf.postfixSaslPasswordPath != null) {
    enable = true;
    relayHost = "smtp.gmail.com";
    relayPort = 587;
    config = {
      smtp_sasl_auth_enable = "yes";
      smtp_sasl_security_options = "noanonymous";
      smtp_tls_security_level = "encrypt";
      smtp_sasl_password_maps = "texthash:${config.environment.sysConf.postfixSaslPasswordPath}";
    };
  };
}
