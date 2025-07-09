{ ... }:
{
  services.yubikey-agent.enable = true;
  programs.ssh = {
    extraConfig = ''
      Host *
        IdentitiesOnly yes
        TCPKeepAlive yes
        ServerAliveInterval 60
    '';
  };
}
