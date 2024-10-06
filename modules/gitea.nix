{ ... }:
{
  services.gitea = {
    enable = true;
    settings = {
      server.HTTP_ADDR = "0.0.0.0";
      server.SSH_PORT = "2222";
    };
  };
}
