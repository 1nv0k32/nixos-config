{ pkgs, self, ... }:
{
  disabledModules = [ "programs/winbox.nix" ];
  imports = [
    (import "${self.inputs.nixpkgs-master}/nixos/modules/programs/winbox.nix")
  ];
  programs.winbox = {
    enable = true;
    openFirewall = true;
    package = pkgs.winbox;
  };
}
