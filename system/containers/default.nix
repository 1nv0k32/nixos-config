{ pkgs, lib, ... }@attrs:
let
  brName = "os1";
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
      address = [ "10.0.1.1/24" ];
    };
  };

  networking.nat = {
    enable = true;
    internalInterfaces = [
      "vb-controller"
      "vb-compute"
    ];
    externalInterface = "wlp1s0";
  };

  containers = {
    controller = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = brName;
      config = (import ./controller.nix attrs);
    };

    compute = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = brName;
      config = (import ./compute.nix attrs);
    };
  };
}
