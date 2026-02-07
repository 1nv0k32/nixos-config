{ ... }:
{
  nix = {
    channel.enable = false;
    gc = {
      automatic = true;
      dates = "daily";
      persistent = true;
      options = "--delete-older-than 3d";
    };

    optimise = {
      automatic = true;
      dates = [ "daily" ];
      # persistent = true;
    };

    settings = {
      min-free = 512 * 1024 * 1024;
      max-free = 3000 * 1024 * 1024;
      download-buffer-size = 268435456;
      tarball-ttl = 0;
      flake-registry = "";
      auto-optimise-store = true;
      trusted-users = [ "@wheel" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # virtualisation = {
  #   vmVariant = {
  #     virtualisation = {
  #       vmVariantWithBootLoader = true;
  #       memorySize = 4096;
  #       cores = 6;
  #     };
  #   };
  # };
}
