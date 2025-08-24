{
  self,
  pkgs,
  lib,
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

  services = {
    resolved = {
      enable = true;
      llmnr = "true";
    };
  };
}
