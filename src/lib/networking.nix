{ ... }:
{
  imports = [
    (import ./networkd.nix)
    (import ./dns.nix)
  ];

  networking = {
    networkmanager = {
      dns = "systemd-resolved";
      settings = {
        main = {
          no-auto-default = "*";
          systemd-resolved = true;
        };
      };
    };
    firewall = {
      enable = false;
      checkReversePath = false;
      allowPing = false;
    };
  };
}
