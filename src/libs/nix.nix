{ ... }:
{
  nix = {
    channel.enable = false;
    optimise = {
      automatic = true;
      dates = [
        "00:00"
        "12:00"
      ];
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
}
