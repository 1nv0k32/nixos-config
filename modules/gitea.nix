{ ... }:
{
  services.gitea = {
    enable = true;
    settings = {
      server = {
        HTTP_ADDR = "0.0.0.0";
        ALLOWED_HOST_LIST = "*";
      };
    };
  };
}
