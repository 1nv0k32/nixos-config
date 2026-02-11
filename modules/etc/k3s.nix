{ config, ... }:
{
  services.k3s = {
    enable = true;
    role = "server";
    clusterInit = true;
    nodeName = config.networking.fqdn;
    extraFlags = "--disable traefik";
  };
}
