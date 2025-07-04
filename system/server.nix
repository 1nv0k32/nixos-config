{ config, ... }:
let
  cfg = config.environment.sysConf;
in
{
  users.users."${cfg.user.name}".openssh.authorizedKeys.keys = [ cfg.user.sshPubKey ];

  services.openssh = {
    enable = true;
    ports = [ cfg.server.sshPort ];
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
