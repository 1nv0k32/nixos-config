{ ... }:
let
  wgInterface = "wg0";
in
{
  networking.nat.internalInterfaces = [ wgInterface ];
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };
}
