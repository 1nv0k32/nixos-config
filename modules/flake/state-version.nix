{ inputs, ... }:
{
  flake.lib = {
    stateVersion = "26.05";
    inherit inputs;
  };
}
