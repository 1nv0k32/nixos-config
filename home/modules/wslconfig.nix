{ pkgs, ... }:
{
  systemd.user.services.wslconfig = {
    Unit.Description = "Automatically set .wslconfig in current windows user";
    Install.WantedBy = [ "default.target" ];
    Service.ExecStart = "${pkgs.writeShellScript "wslconfig-sh" ''
      set -e
      CURRENT_USER=$(/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe '$env:UserName')
      CURRENT_USER=''${CURRENT_USER//[^a-zA-Z0-9]/}
      WSLCONFIG_FILE=/mnt/c/Users/$CURRENT_USER/.wslconfig
      CONFIG=$(${pkgs.coreutils}/bin/cat <<EOF
      ### START GENERATED WSLCONFIG
      ### DO NOT ADD ANYTHING BETWEEN COMMENTS
      [wsl2]
      kernelCommandLine = vsyscall=emulate
      networkingMode=mirrored
      autoProxy=false
      firewall=false
      [experimental]
      sparseVhd=true
      autoMemoryReclaim=gradual
      ### END GENERATED WSLCONFIG
      EOF
      )
      ${pkgs.gnused}/bin/sed -in '/### START GENERATED WSLCONFIG/,/### END GENERATED WSLCONFIG/ {/.*/d}' $WSLCONFIG_FILE
      echo "$CONFIG" >> $WSLCONFIG_FILE
    ''}";
  };
}

# vim:expandtab ts=2 sw=2
