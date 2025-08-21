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

  services = {
    resolved.enable = true;
  };
}
