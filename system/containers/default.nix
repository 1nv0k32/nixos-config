{ ... }@attrs:
{
  containers = {
    os-master = {
      autoStart = true;
      privateNetwork = true;
      config = (import ./os-master.nix attrs);
    };

    os-slave = {
      autoStart = true;
      privateNetwork = true;
      config = (import ./os-slave.nix attrs);
    };
  };
}
