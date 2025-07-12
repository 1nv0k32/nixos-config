{
  self,
  config,
  ...
}:
let
  cfg = config.environment.sysConf;
in
{
  users.groups."ubridge" = {
    name = "ubridge";
  };

  users.users."${cfg.user.name}" = {
    initialPassword = "${cfg.user.name}";
    uid = 1000;
    isNormalUser = true;
    linger = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "podman"
      "libvirtd"
      "ubridge"
      "wireshark"
      "dialout"
    ];
  };

  users.users."guest" = {
    uid = 1001;
    isNormalUser = true;
    password = "guest";
  };

  home-manager = {
    sharedModules = [ (import "${self}/home/base.nix") ];
    extraSpecialArgs = {
      inherit (self) stateVersion;
    };
  };

  home-manager.users = {
    "${cfg.user.name}" =
      { ... }:
      {
        home.username = cfg.user.name;

        programs.git = {
          userName = cfg.git.username;
          userEmail = cfg.git.email;
        };
      };

    "guest" =
      { ... }:
      {
        home.username = "guest";
      };
  };
}
