{ ... }:
{
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
      };
    };
    initrd.systemd.enable = true;
  };
}
