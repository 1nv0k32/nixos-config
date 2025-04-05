{ defaultInterface, pkgs, ... }:
let
  wgInterface = "wg0";
  wgIPRange = "10.100.0.1/24";
  wgPort = 22531;
in
{
  networking.nat.internalInterfaces = [ wgInterface ];
  networking.firewall = {
    allowedUDPPorts = [ wgPort ];
  };

  networking.wireguard.interfaces = {
    ${wgInterface} = {
      ips = [ wgIPRange ];
      listenPort = wgPort;

      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${wgIPRange} -o ${defaultInterface} -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${wgIPRange} -o ${defaultInterface} -j MASQUERADE
      '';
    };
  };
}
