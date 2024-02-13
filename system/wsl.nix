{ pkgs, lib, options, ... }:
with lib;
let
  alpaca = pkgs.stdenv.mkDerivation rec {
    pname = "alpaca";
    version = "2.0.3";
    src = pkgs.fetchurl {
      url = "https://github.com/samuong/alpaca/releases/download/v${version}/alpaca_v${version}_linux-amd64";
      sha256 = "HFT6URkSOtJLKcCRs/epHFeLgZxVh5YEYJJtl74MokM=";
    };
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    phases = [ "installPhase" ];
    installPhase = ''
      install -m755 -D $src $out/bin/${pname}
      autoPatchelf $out/bin/${pname}
    '';
  };

  proxy = "http://localhost:3128";
  proxies = {
    no_proxy = "127.0.0.1,localhost";
    ftp_proxy = proxy;
    https_proxy = proxy;
    HTTPS_PROXY = proxy;
    http_proxy = proxy;
    HTTP_PROXY = proxy;
    all_proxy = proxy;
    rsync_proxy = proxy;
  };
in
{
  imports = [
    <nixos-wsl/modules>
  ];

  wsl = {
    enable = true;
    defaultUser = "rick";
  };

  home-manager.users."rick".programs.git = {
    userName = mkDefault "Name";
    userEmail = mkDefault "Name@domain.local";
  };

  systemd.services = {
    systemd-resolved.enable = mkForce false;
    "alpaca" = {
      enable = true;
      description = "alpaca proxy service";
      serviceConfig = {
        ExecStart = "${alpaca}/bin/alpaca -l 0.0.0.0 -p 3128 $PACURL";
        Restart = "always";
        KillMode = "mixed";
      };
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        NTLM_CREDENTIALS = mkDefault "NTLM";
        PACURL = mkDefault "-C PROXYURL";
      };
    };
    nix-daemon.environment = proxies;
    k3s.environment = proxies;
  };

  boot.loader.systemd-boot.enable = mkForce false;
  networking = {
    networkmanager.enable = mkForce false;
    firewall.enable = mkForce false;
    proxy.default = mkForce proxy;
  };

  virtualisation.docker.daemon.settings = {
    iptables = false;
    ipv6 = false;
  };

  environment = {
    systemPackages = with pkgs; [ git-crypt ];
  };
}

# vim:expandtab ts=2 sw=2
