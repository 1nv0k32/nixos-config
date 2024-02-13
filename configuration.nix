{ lib
, ...
}:
let
  configRepo = builtins.fetchGit {
    url = "https://github.com/1nv0k32/NixOS.git";
    ref = "main";
  };
in
{
  imports = [ ]
    ++ lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix
    ++ lib.optional (builtins.pathExists ./local.nix) ./local.nix
    ++ [
    (import "${configRepo}/src")
    (import "${configRepo}/system/vm.nix")
    #(import "${configRepo}/system/z13.nix")
    #(import "${configRepo}/system/usb.nix")
    #(import "${configRepo}/system/wsl.nix")
  ];
}

# vim:expandtab ts=2 sw=2

