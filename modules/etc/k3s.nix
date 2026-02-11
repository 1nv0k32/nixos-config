{ config, ... }:
{
  services.k3s = {
    enable = true;
    role = "server";
    clusterInit = true;
    nodeName = config.networking.hostName;
    extraFlags = "--disable traefik";
  };
}
