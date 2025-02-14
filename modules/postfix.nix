{ config, ... }:
{
  sops.secrets."postfix/sasl_passwd" = { };
  services.postfix = {
    enable = true;
    relayHost = "smtp.gmail.com";
    relayPort = 587;
    config = {
      smtp_use_tls = "yes";
      smtp_sasl_auth_enable = "yes";
      smtp_sasl_password_maps = "texthash:${config.sops.secrets."postfix/sasl_passwd".path}";
    };
  };
}
