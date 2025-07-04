{
  lib,
  config,
  pkgs,
  self,
  ...
}:
{
  disabledModules = [ "programs/winbox.nix" ];
  imports = [
    (import "${self.inputs.nixpkgs-master}/nixos/modules/programs/winbox.nix")
  ];

  config = lib.mkIf config.environment.sysConf.x86 {
    programs.winbox = {
      enable = true;
      openFirewall = true;
      package = pkgs.winbox;
    };
  };
}
