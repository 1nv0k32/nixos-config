{ pkgs, lib, ... }@attrs:
let
  brName = "os1";
  netmask = "24";
  hostAddr = "10.0.1.1";
  controllerAddr = "10.0.1.100";
  computeAddr = "10.0.1.101";
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
      address = [ "${hostAddr}/${netmask}" ];
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
            ipAddr = "${controllerAddr}/${netmask}";
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
            ipAddr = "${computeAddr}/${netmask}";
            ipGateway = hostAddr;
          }
        )
      );
    };
  };
}
