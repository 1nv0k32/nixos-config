{
  lib,
  pkgs,
  self,
  ...
}:
{
  disabledModules = [ "programs/winbox.nix" ];
  imports = [
    (import "${self.inputs.nixpkgs-master}/nixos/modules/programs/winbox.nix")
  ];

  config = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
    programs.winbox = {
      enable = true;
      openFirewall = true;
      package = pkgs.winbox;
    };
  };
}
