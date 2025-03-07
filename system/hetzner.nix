{ lib, ... }:
{
  boot = {
    loader = {
      grub.enable = true;
    };
    initrd.systemd.enable = true;
  };
}
