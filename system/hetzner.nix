{ ... }:
{
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda1";
      };
    };
    initrd.systemd.enable = true;
  };
}
