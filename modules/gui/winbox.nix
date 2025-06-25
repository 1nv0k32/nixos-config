{ pkgs, self, ... }:
{
  imports = [
    (import "${self.inputs.nixpkgs-unstable}/nixos/modules/programs/winbox.nix")
  ];
  # networking.firewall.allowedUDPPortRanges = [
  #   {
  #     from = 40000;
  #     to = 50000;
  #   }
  # ];
  programs.winbox = {
    enable = true;
    openFirewall = true;
    package = pkgs.pkgs-unstable.winbox;
  };
}
