{ self, ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    imports = [
      "${self}/pkgs/src/nixvim.nix"
    ];
  };
}
