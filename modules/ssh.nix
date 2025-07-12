{ ... }:
{
  services.yubikey-agent.enable = true;
  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      Host *
        IdentitiesOnly yes
        TCPKeepAlive yes
        ServerAliveInterval 60
    '';
  };
}
