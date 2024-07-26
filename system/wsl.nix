{
  inputs,
  pkgs,
  lib,
  options,
  config,
  ...
}:
let
  mainUser = config.environment.sysConf.mainUser;
in
with lib;
{
  imports = [
    (import "${inputs.nixos-wsl}/modules")
    (import "${inputs.vscode-server}")
  ];

  wsl = {
    enable = true;
    startMenuLaunchers = true;
    defaultUser = mainUser;
    extraBin = with pkgs; [
      { src = "${coreutils}/bin/uname"; }
      { src = "${coreutils}/bin/dirname"; }
      { src = "${coreutils}/bin/readlink"; }
      { src = "${coreutils}/bin/cat"; }
      { src = "${wget}/bin/wget"; }
      { src = "${curl}/bin/curl"; }
      { src = "${getconf}/bin/getconf"; }
      { src = "${gnused}/bin/sed"; }
    ];
  };

  nixpkgs.config.permittedInsecurePackages = [ "${pkgs.python27Full.name}" ];

  environment = {
    variables = {
      ORACLE_HOME = "${pkgs.oracle-instantclient.lib}";
      PYTHON_KEYRING_BACKEND = "keyring.backends.fail.Keyring";
    };
    systemPackages = with pkgs; [
      poetry
      python312
      python27Full
      mdbook
      mdbook-mermaid
      mdbook-linkcheck
    ];
  };

  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        zlib
        libgcc
      ];
    };
  };

  virtualisation = {
    podman.dockerCompat = false;
    docker = {
      enable = true;
      daemon.settings = {
        iptables = false;
        ipv6 = false;
      };
    };
  };

  services = {
    vscode-server.enable = true;
  };

  home-manager.users = {
    "${mainUser}" =
      { ... }:
      {
        imports = [ (import "${inputs.vscode-server}/modules/vscode-server/home.nix") ];

        systemd.user.services.wslconfig = {
          Unit.Description = "Automatically set .wslconfig in current windows user";
          Install.WantedBy = [ "default.target" ];
          Service.ExecStart = "${pkgs.writeShellScript "wslconfig-sh" ''
            set -e
            CURRENT_USER=$(/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe '$env:UserName')
            CURRENT_USER=\${CURRENT_USER//[^a-zA-Z0-9]/}
            cat << EOF > /mnt/c/Users/${CURRENT_USER}/.wslconfig
            [wsl2]
            kernelCommandLine = vsyscall=emulate cgroup_no_v1=all systemd.unified_cgroup_hierarchy=1
            networkingMode=mirrored
            autoProxy=false
            firewall=false
            [experimental]
            sparseVhd=true
            EOF
          ''}";
        };
      };
  };
}

# vim:expandtab ts=2 sw=2
