{
  lib,
  ...
}:
{
  flake.modules.nixos.programs-ssh = { lib, ... }: {
    programs.ssh = {
      startAgent = true;
      extraConfig = ''
        AddKeysToAgent yes
        Host *
          IdentitiesOnly yes
          TCPKeepAlive yes
          ServerAliveInterval 60
      '';
    };
    services.gnome.gcr-ssh-agent.enable = lib.mkForce false;
  };
}
