{ config, ... }:
{
  services.gitea = {
    enable = true;
    settings = {
      server.HTTP_ADDR = "0.0.0.0";
      server.DOMAIN = "${config.networking.hostName}";
      webhook.ALLOWED_HOST_LIST = "*";
    };
  };
}
