{ pkgs, lib, ... }@attrs:
let
  brName = "os1";
in
{
  systemd.network = {
    netdevs."20-${brName}" = {
      netdevConfig = {
        Kind = "Bridge";
        Name = brName;
      };
    };
    networks."30-${brName}" = {
      matchConfig.Name = brName;
      bridgeConfig = { };
    };
  };

  containers = {
    controller = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = brName;
      localAddress = "10.0.1.100/24";
      config = (import ./controller.nix attrs);
    };

    compute = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = brName;
      localAddress = "10.0.1.101/24";
      config = (import ./compute.nix attrs);
    };
  };
}
