{
  modulesPath,
  stateVersion,
  hostName,
  config,
  pkgs,
  lib,
  ...
}:
let
  customConfigs = (import ./configs.nix { inherit modulesPath pkgs lib; });
in
with lib;
{
  imports = [ (import ./users.nix) ];

  nix = {
    optimise = {
      automatic = true;
      dates = [
        "00:00"
        "12:00"
      ];
    };
    settings = {
      flake-registry = "";
      auto-optimise-store = true;
      tarball-ttl = 0;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  documentation.nixos.enable = false;

  system = {
    stateVersion = stateVersion;
  };

  networking = {
    hostName = hostName;
  };

  systemd = {
    extraConfig = customConfigs.SYSTEMD_CONFIG;
    user.extraConfig = customConfigs.SYSTEMD_USER_CONFIG;
  };

  time = {
    timeZone = "CET";
    hardwareClockInLocalTime = false;
  };

  i18n.defaultLocale = "en_GB.UTF-8";

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = mkForce "1";
    };
    variables = {
      VAGRANT_DEFAULT_PROVIDER = mkForce "libvirt";
      LIBVIRT_DEFAULT_URI = mkForce "qemu:///system";
    };
    etc = {
      "inputrc".text = customConfigs.INPUTRC_CONFIG;
      "bashrc.local".text = customConfigs.BASHRC_CONFIG;
      "wireplumber/policy.lua.d/99-bluetooth-policy.lua".text = ''
        bluetooth_policy.policy["media-role.use-headset-profile"] = false
      '';
    };
  };

  programs = {
    ssh.extraConfig = customConfigs.SSH_CLIENT_CONFIG;

    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
      enableSSHSupport = true;
    };
    git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        color.ui = "auto";
        push.autoSetupRemote = true;
        push.default = "current";
        pull.rebase = true;
        fetch.prune = true;
        fetch.pruneTags = true;
        alias.acommit = "commit --amend --no-edit --all";
        alias.fpush = "push --force-with-lease";
        rerere.enabled = true;
      };
    };
  };
}
