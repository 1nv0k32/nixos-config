{
  self,
  ...
}:
{
  flake.modules.nixos.programs-nixvim = { self, ... }: {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      imports = [
        "${self}/modules/_lib/nixvim-config.nix"
      ];
    };
  };
}
