{ pkgs, lib, options, ... }:
with lib;
{
  imports = [
    <nixos-wsl/modules>
  ];

  wsl = {
    enable = true;
    defaultUser = "rick";
    extraBin = with pkgs; [
      { src = "${coreutils}/bin/uname"; }
    ];
  };
  boot.loader.systemd-boot.enable = mkForce false;

  home-manager.users."rick".programs.git = {
    userName = mkDefault "Name";
    userEmail = mkDefault "Name@domain.local";
  };

  services = {
    xserver.enable = mkForce false;
    pipewire.enable = mkForce false;
    resolved.enable = mkForce false;
  };

  programs = {
    nix-ld.enable = true;
  };

  networking = {
    networkmanager.enable = mkForce false;
    firewall.enable = mkForce false;
  };

  virtualisation.docker.daemon.settings = {
    iptables = false;
    ipv6 = false;
  };

  systemd.services.tmux-background = {
    enable = true;
    description = "tmux background service";
    serviceConfig = {
      Type = "exec";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.tmux}/bin/tmux new-session -d -s background || true'";
    };
    wantedBy = [ "multi-user.target" ];
  };
}

# vim:expandtab ts=2 sw=2

