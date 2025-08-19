{ ... }@attrs:
{
  containers = {
    pod01 = {
      autoStart = true;
      privateNetwork = false;
      config = (import ./pod01.nix attrs);
    };
  };
}
