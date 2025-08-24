{ pkgs, lib, ... }@attrs:
let
  brName = "os1";
  hostAddr = "10.0.1.1/24";
  controllerAddr = "10.0.1.100/24";
  computeAddr = "10.0.1.101/24";
in
{
  systemd.network = {
    netdevs."20-${brName}" = {
      netdevConfig = {
        Kind = "bridge";
        Name = brName;
      };
    };
    networks."30-${brName}" = {
      matchConfig.Name = brName;
      bridgeConfig = { };
      address = [ hostAddr ];
    };
  };

  containers = {
    controller = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = brName;
      config = (
        import ./controller.nix (
          attrs
          // {
            ipAddr = controllerAddr;
            ipGateway = hostAddr;
          }
        )
      );
    };

    compute = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = brName;
      config = (
        import ./compute.nix (
          attrs
          // {
            ipAddr = computeAddr;
            ipGateway = hostAddr;
          }
        )
      );
    };
  };
}
