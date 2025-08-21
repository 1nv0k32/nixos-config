{ self, pkgs, ... }:
{
  system = {
    stateVersion = self.nixosModules.stateVersion;
  };

  environment.systemPackages = with pkgs; [
    vim
    openstackclient-full
  ];
}
