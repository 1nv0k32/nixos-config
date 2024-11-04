{ ... }:
{
  programs.ssh = {
    extraConfig = ''
      Host *
        IdentitiesOnly yes
        TCPKeepAlive yes
        ServerAliveInterval 60
    '';
  };
}
