{ ... }:
{
  services.k3s = {
    enable = true;
    role = "server";
    clusterInit = true;
    extraFlags = "--disable traefik";
  };
}
