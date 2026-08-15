{
  inputs,
  self,
  ...
}:
{
  perSystem = { system, pkgs, ... }: {
    packages.nvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
      inherit pkgs;
      module = import "${self}/modules/_lib/nixvim-config.nix";
    };
  };
}
