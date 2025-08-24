{ ... }:
{
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
      enable = true;
      checkReversePath = false;
      allowPing = false;
    };
  };
}
