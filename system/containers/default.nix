{ ... }@attrs:
{
  containers = {
    os-master = {
      autoStart = true;
      privateNetwork = false;
      config = (import ./os-master.nix attrs);
    };

    os-slave = {
      autoStart = true;
      privateNetwork = false;
      config = (import ./os-slave.nix attrs);
    };
  };
}
