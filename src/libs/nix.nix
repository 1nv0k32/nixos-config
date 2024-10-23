{ ... }:
{
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
}