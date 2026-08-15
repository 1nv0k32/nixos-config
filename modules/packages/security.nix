{
  pkgs,
  ...
}:
{
  flake.modules.nixos.packages-security = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      cryptsetup
      tpm2-tss
      pass
      conntrack-tools
      nftables
      openvpn
      ubridge
      nmap
      radare2
      binwalk
      platformio-core
      proxmark3
    ];

    services.udev.packages = with pkgs; [
      platformio-core.udev
      proxmark3
    ];
  };
}
