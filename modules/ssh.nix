{ ... }:
{
  services.yubikey-agent.enable = true;
  programs.ssh = {
    startAgent = false;
    extraConfig = ''
      Host *
        IdentitiesOnly yes
        TCPKeepAlive yes
        ServerAliveInterval 60
    '';
  };
}
