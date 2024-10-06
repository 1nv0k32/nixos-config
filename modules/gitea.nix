{ ... }:
{
  services.gitea = {
    enable = true;
    settings = {
      server.HTTP_ADDR = "0.0.0.0";
      webhook.ALLOWED_HOST_LIST = "*";
    };
  };
}
