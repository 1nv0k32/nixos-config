{ pkgs, lib, ... }:
let
  yk-ssh-keygen = pkgs.writeShellScriptBin "yk-ssh-keygen" ''
    set -euo pipefail
    UID=$1
    if [ -z "$UID" ]; then
      echo "Usage: $0 <user-id>"
      exit 1
    fi
    ${pkgs.openssh}/bin/ssh-keygen -t ed25519-sk -O resident -O application=ssh:$UID
  '';
in
{
  environment.systemPackages = with pkgs; [
    yk-ssh-keygen
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
