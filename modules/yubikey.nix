{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    pam_u2f
    yubico-piv-tool
    yubikey-manager
    yubioath-flutter
  ];

  environment.etc.u2f_mappings.text = lib.mkDefault '''';

  services = {
    pcscd.enable = true;
    yubikey-agent.enable = true;
  };

  security = {
    pam = {
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
      u2f.settings = {
        cue = true;
        userpresence = 0;
        authfile = "/etc/u2f_mappings";
      };
    };
  };
}
