{ lib, config, ... }:
let
  cfg = config.environment.sysConf;
in
{
  options.environment.sysConf = {
    user = {
      sshPubKey = lib.mkOption {
        type = lib.types.str;
        default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJ414vPwc8EjJPtKSGTSUCWuSQNifNI3pv+/sodmkAd8Ww6ofCxPcrJ1UjgTXis2Oqk2I1EGtRnD2ozom+jW+AZ5R00Ht2+1RGD+dkd0rrIqi+HFEVFPUDCu1pAZnLOzfGrFGpHpWkrbDqtv7OFA60g9iIAaId1Fi1VOSR43s4XYmTmWio7R090LW6aENb+jc2vW7VSKq/MlgTtvfKEHm187RFNHf+2BGp8Cdq6rwSEbzkkiQ9kI0W6JxCGRRDf0qIoAu6TVpjoHlzXAEFUZaz4EtxM2EmyhiRop4vVougUqtnRTzq8+RRMoVECXOylJGWbd8MX25MnRbCGph7UXuZ8sGrvwsJBjbDhWRuIgYfJdnf+ymuki361F8qIvBC7xHsBGVfEpVXcGuSC9GaBw8Y3XLMBtpcUXfuT1Tz1O/U+QwC5mdAgGwZ2BQkBfP8edtpeg5LkSgcU7F4LPaXAEnzievqljyS4UUV0vqF/2iTM72q8wlM5XO7GsWkY7/B6g/Ha3080yypUza9lG20CAaeCso4CsjehF3qd4S4BcZeXUpaOUYHYk6f2M/QEReAY1viJAsx4o6dQ2sArg8JM/5IWBRWzM/NK+RrPvCWzk8lmsMBEaKkPWEpBe7H07qbOn2fDDBQxL0ImoGdXtqLNH7lOZGYZVKbZZ5ZknZB4EeIKQ== rick@nyx";
        description = "The main user's trusted SSH key";
      };
    };

    server = {
      sshPort = lib.mkOption {
        type = lib.types.int;
        default = 2222;
      };
    };
  };

  config = {
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
  };
}
