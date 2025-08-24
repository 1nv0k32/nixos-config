{
  self,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    (import "${self}/src/lib/networkd.nix")
    (import "${self}/src/lib/dns.nix")
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
  };
}
