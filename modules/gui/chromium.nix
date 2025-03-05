{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    chromium
    # (chromium.override {
    #   commandLineArgs = [
    #     "--enable-features=AcceleratedVideoEncoder"
    #     "--ignore-gpu-blocklist"
    #     "--enable-zero-copy"
    #   ];
    # })
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "ponfpcnoihfmfllpaingbgckeeldkhle" # enhancer for youtube
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
    ];
  };
}
