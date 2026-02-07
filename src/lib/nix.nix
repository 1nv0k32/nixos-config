{ lib, pkgs, ... }:
{
  nix = {
    channel.enable = false;
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    }
    // lib.mkIf (pkgs.stdenv.hostPlatform.system != "aarch64-darwin") {
      dates = "daily";
      persistent = true;
    };

    optimise = {
      automatic = true;
    }
    // lib.mkIf (pkgs.stdenv.hostPlatform.system != "aarch64-darwin") {
      dates = [ "daily" ];
      persistent = true;
    };

    settings = {
      min-free = 512 * 1024 * 1024;
      max-free = 3000 * 1024 * 1024;
      download-buffer-size = 268435456;
      tarball-ttl = 0;
      flake-registry = "";
      trusted-users = [ "@wheel" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    }
    // lib.mkIf (pkgs.stdenv.hostPlatform.system != "aarch64-darwin") {
      auto-optimise-store = true;
    };
  };
}
