{ pkgs, ... }:
{
  systemd.user.services.wslconfig = {
    Unit.Description = "Automatically set .wslconfig in current windows user";
    Install.WantedBy = [ "default.target" ];
    Service.ExecStart = "${pkgs.writeShellScript "wslconfig-sh" ''
      #!${pkgs.bash}/bin/bash
      set -e
      CURRENT_USER=$(/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe '$env:UserName')
      CURRENT_USER=''${CURRENT_USER//[^a-zA-Z0-9]/}
      ${pkgs.coreutils}/bin/cat << EOF > /mnt/c/Users/$CURRENT_USER/.wslconfig
      [wsl2]
      kernelCommandLine = vsyscall=emulate
      networkingMode=mirrored
      autoProxy=false
      firewall=false
      [experimental]
      sparseVhd=true
      EOF
    ''}";
  };
}

# vim:expandtab ts=2 sw=2
