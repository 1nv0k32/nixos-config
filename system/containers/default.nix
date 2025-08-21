{ ... }@attrs:
{
  containers = {
    os-master = {
      autoStart = true;
      privateNetwork = true;
      config = (import ./controller.nix attrs);
    };

    os-slave = {
      autoStart = true;
      privateNetwork = true;
      config = (import ./compute.nix attrs);
    };
  };
}
