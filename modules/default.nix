{ ... }:
{
  imports = [ ]
    ++ lib.optional (builtins.pathExists ./dev.nix) ./dev.nix
    ++ [
    ./cert_der.nix
    ./alpaca.nix
  ];
}

# vim:expandtab ts=2 sw=2

