{
  pkgs,
  ...
}:
{
  flake.modules.nixos.packages-base = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      openssl
      nixos-anywhere
      sops
      git-crypt
      tree
      file
      htop
      aria2
      wget
      iperf3
      dig
      screen
      unzip
      kubectl
      jq
      yq
      wireguard-tools
      nixd
    ];
  };
}
