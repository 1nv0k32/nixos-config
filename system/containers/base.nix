{
  self,
  pkgs,
  lib,
  address,
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
      address = [ address ];
    };
  };

  services = {
    resolved = {
      enable = true;
      llmnr = "true";
    };
  };
}
