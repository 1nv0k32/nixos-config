{
  inputs,
  pkgs,
  lib,
  options,
  config,
  ...
}:
with lib;
{
  imports = [ (import "${inputs.nixos-wsl}/modules") ];

  wsl = {
    enable = true;
    defaultUser = config.environment.sysConf.mainUser;
    startMenuLaunchers = true;
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

  virtualisation.docker.daemon.settings = {
    iptables = false;
    ipv6 = false;
  };
}

# vim:expandtab ts=2 sw=2
