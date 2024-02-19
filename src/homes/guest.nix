{ customPkgs, systemConfig, ... }: { ... }: {
  home-manager.users."guest" = { ... }: {
    home = {
      username = "guest";
    };

    imports = [ (import ./base.nix { inherit customPkgs systemConfig; }) ];
  };
}

# vim:expandtab ts=2 sw=2

