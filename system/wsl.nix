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
    nix-ld.enable = true;
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
      };
  };
}

# vim:expandtab ts=2 sw=2
