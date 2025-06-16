{ ... }:
{
  containers = {
    server01 = {
      autoStart = true;
      privateNetwork = true;
      config = import ./server01.nix;
    };
  };
}
