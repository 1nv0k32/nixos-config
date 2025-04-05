{ defaultInterface, pkgs, ... }:
let
  wgInterface = "wg0";
  wgIPRange = "10.100.0.1/24";
  wgPort = 51820;
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

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${wgIPRange} -o ${defaultInterface} -j MASQUERADE
      '';

      # peers = [
      #   {
      #     publicKey = "{client public key}";
      #     allowedIPs = [ "10.100.0.2/32" ];
      #   }
      # ];
    };
  };
}
