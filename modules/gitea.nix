{ config, ... }:
{
  services.gitea = {
    enable = true;
    settings = {
      server.HTTP_ADDR = "0.0.0.0";
      server.ROOT_URL = "http://${config.networking.hostName}:22/";
      webhook.ALLOWED_HOST_LIST = "*";
    };
  };
}
