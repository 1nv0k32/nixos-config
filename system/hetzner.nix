{ config, ... }:
let
  mainUser = config.environment.sysConf.mainUser;
  mainUserSSHKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJ414vPwc8EjJPtKSGTSUCWuSQNifNI3pv+/sodmkAd8Ww6ofCxPcrJ1UjgTXis2Oqk2I1EGtRnD2ozom+jW+AZ5R00Ht2+1RGD+dkd0rrIqi+HFEVFPUDCu1pAZnLOzfGrFGpHpWkrbDqtv7OFA60g9iIAaId1Fi1VOSR43s4XYmTmWio7R090LW6aENb+jc2vW7VSKq/MlgTtvfKEHm187RFNHf+2BGp8Cdq6rwSEbzkkiQ9kI0W6JxCGRRDf0qIoAu6TVpjoHlzXAEFUZaz4EtxM2EmyhiRop4vVougUqtnRTzq8+RRMoVECXOylJGWbd8MX25MnRbCGph7UXuZ8sGrvwsJBjbDhWRuIgYfJdnf+ymuki361F8qIvBC7xHsBGVfEpVXcGuSC9GaBw8Y3XLMBtpcUXfuT1Tz1O/U+QwC5mdAgGwZ2BQkBfP8edtpeg5LkSgcU7F4LPaXAEnzievqljyS4UUV0vqF/2iTM72q8wlM5XO7GsWkY7/B6g/Ha3080yypUza9lG20CAaeCso4CsjehF3qd4S4BcZeXUpaOUYHYk6f2M/QEReAY1viJAsx4o6dQ2sArg8JM/5IWBRWzM/NK+RrPvCWzk8lmsMBEaKkPWEpBe7H07qbOn2fDDBQxL0ImoGdXtqLNH7lOZGYZVKbZZ5ZknZB4EeIKQ== rick@nyx";
  defaultInterface = "enp1s0";
in
{
  imports = [
    (import ../modules/wg_server.nix { inherit defaultInterface; })
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
