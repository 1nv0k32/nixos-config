{ ... }:
{
  flake.modules.nixos.roles-server = { config, ... }: {
    users.users."${config.environment.sysConf.user.name}".openssh.authorizedKeys.keys =
      config.environment.sysConf.user.sshPubKeys;

    services.openssh = {
      enable = true;
      ports = [ config.environment.sysConf.server.sshPort ];
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };
}
