{ customPkgs, systemConfig, stateVersion, ... }: { ... }: {
  home-manager.users."guest" = { ... }: {
    home = {
      username = "guest";
    };

    imports = [ (import ./base.nix { inherit stateVersion customPkgs systemConfig; }) ];
  };
}

# vim:expandtab ts=2 sw=2

