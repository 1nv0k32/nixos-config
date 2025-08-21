{ pkgs, ... }@attrs:
{
  containers = {
    controller = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.0.0.1";
      localAddress = "10.0.0.10";
      config = (import ./controller.nix attrs);
    };

    compute = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.0.0.2";
      localAddress = "10.0.0.11";
      config = (import ./compute.nix attrs);
    };
  };
}
