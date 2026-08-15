{
  pkgs,
  ...
}:
{
  perSystem = { pkgs, ... }: {
    formatter = pkgs.nixfmt-tree;
  };
}
