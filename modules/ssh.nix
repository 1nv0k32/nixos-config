{ ... }:
{
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
}
