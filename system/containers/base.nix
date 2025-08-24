{
  self,
  pkgs,
  lib,
  ...
}:
{
  system = {
    stateVersion = self.nixosModules.stateVersion;
  };

  environment.systemPackages = with pkgs; [
    vim
    openstackclient-full
  ];

  networking = {
    useHostResolvConf = lib.mkForce false;
  };

  systemd.network = {
    enable = true;
    wait-online.enable = false;
    networks."10-eth0" = {
      matchConfig.Name = "eth0";
      routes = [ { Gateway = "10.0.1.1"; } ];
    };
  };

  services = {
    resolved.enable = true;
  };
}
