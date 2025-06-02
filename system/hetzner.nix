{
  lib,
  pkgs,
  config,
  ...
}:
let
  mainUser = config.environment.sysConf.mainUser;
  mainUserSSHKey = config.environment.sysConf.mainUserSSHKey;
  defaultInterface = "enp1s0";
in
{
  imports = [
    (import ../modules/wg_server.nix { inherit lib pkgs defaultInterface; })
  ];

  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/sda";
    };
    initrd.systemd.enable = true;
  };

  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users."${mainUser}".openssh.authorizedKeys.keys = [ mainUserSSHKey ];

  networking = {
    nat = {
      enable = true;
      externalInterface = defaultInterface;
    };
    interfaces.${defaultInterface} = {
      useDHCP = false;
      ipv4.addresses = [ ];
      ipv4.routes = [
        {
          address = "0.0.0.0";
          prefixLength = 0;
          via = "172.31.1.1";
          options.onlink = "";
        }
      ];
      ipv6.addresses = [ ];
      ipv6.routes = [
        {
          address = "::";
          prefixLength = 0;
          via = "fe80::1";
          options.onlink = "";
        }
      ];
    };
  };
}
