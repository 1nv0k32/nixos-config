{ ... }@attrs:
{
  containers = {
    pod01 = {
      autoStart = true;
      privateNetwork = true;
      config = (import ./pod01.nix attrs);
    };
  };
}
