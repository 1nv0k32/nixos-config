{ pkgs, self, ... }:
{
  imports = [
    (import "${self.inputs.nixpkgs-test}/nixos/modules/programs/winbox.nix")
  ];
  # networking.firewall.allowedUDPPortRanges = [
  #   {
  #     from = 40000;
  #     to = 50000;
  #   }
  # ];
  programs.winboxx = {
    enable = true;
    openFirewall = true;
    package = pkgs.pkgs-unstable.winbox;
  };
}
