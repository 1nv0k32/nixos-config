{
  self,
  pkgs,
  lib,
  ipAddr,
  ipGateway,
  ...
}:
{
  imports = [
    (import "${self}/src/lib/networkd.nix")
  ];

  system = {
    stateVersion = self.nixosModules.stateVersion;
  };

  environment.systemPackages = with pkgs; [
    vim
    openstackclient-full
  ];

  networking = {
    useHostResolvConf = lib.mkForce false;
    firewall.enable = false;
  };

  systemd.network = {
    networks."10-eth0" = {
      matchConfig.Name = "eth0";
      address = [ ipAddr ];
      routes = [
        { Gateway = ipGateway; }
      ];
    };
  };

  services = {
    resolved = {
      enable = true;
      llmnr = "true";
    };
  };
}
