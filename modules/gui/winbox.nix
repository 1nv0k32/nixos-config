{
  lib,
  config,
  pkgs,
  self,
  ...
}:
{
  config = lib.mkIf config.environment.sysConf.x86 {
    disabledModules = [ "programs/winbox.nix" ];
    imports = [
      (import "${self.inputs.nixpkgs-master}/nixos/modules/programs/winbox.nix")
    ];
    programs.winbox = {
      enable = true;
      openFirewall = true;
      package = pkgs.winbox;
    };
  };
}
