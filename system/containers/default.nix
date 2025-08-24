{ pkgs, lib, ... }@attrs:
{
  networking = {
    bridges.os1.interfaces = [ ];
    interfaces.os1 = {
      ipv4.addresses = [
        {
          address = "10.0.1.1";
          prefixLength = 24;
        }
      ];
    };
  };

  containers = {
    controller = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = "os1";
      localAddress = "10.0.1.100/24";
      config = (import ./controller.nix attrs);
    };

    compute = {
      autoStart = true;
      privateNetwork = true;
      localAddress = "10.0.1.101/24";
      config = (import ./compute.nix attrs);
    };
  };
}
