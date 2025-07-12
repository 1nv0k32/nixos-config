{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pam_u2f
    yubico-piv-tool
    yubikey-manager
    yubioath-flutter
  ];

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
        userpresence = 1;
      };
    };
  };
}
