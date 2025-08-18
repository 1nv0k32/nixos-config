{ ... }@attrs:
{
  containers = {
    os-controller = {
      autoStart = true;
      privateNetwork = true;
      config = (import ./os-controller.nix attrs);
    };

    os-compute = {
      autoStart = true;
      privateNetwork = true;
      config = (import ./os-compute.nix attrs);
    };
  };
}
