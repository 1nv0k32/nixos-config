{ pkgs, lib, ... }@attrs:
{
  containers = {
    controller = {
      autoStart = true;
      privateNetwork = true;
      config = (import ./controller.nix attrs);
    };

    compute = {
      autoStart = true;
      privateNetwork = true;
      config = (import ./compute.nix attrs);
    };
  };
}
