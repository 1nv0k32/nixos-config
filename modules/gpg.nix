{ pkgs, ... }:
{
  # services.pcscd.enable = false;
  programs.gnupg.agent = {
    enable = false;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };
}
