{
  lib,
  ...
}:
{
  flake.modules.nixos.system-boot = { lib, ... }: {
    boot = {
      tmp.cleanOnBoot = true;
      blacklistedKernelModules = [ "snd_pcsp" ];

      consoleLogLevel = 0;
      plymouth.enable = true;
      initrd.verbose = false;
      loader = {
        efi.canTouchEfiVariables = lib.mkDefault true;
        timeout = lib.mkDefault 0;
        systemd-boot = {
          enable = lib.mkDefault true;
          editor = lib.mkForce false;
          consoleMode = lib.mkDefault "max";
        };
      };
      kernelParams = lib.mkAfter [
        "quiet"
        "splash"
        "udev.log_level=3"
      ];
    };
  };
}
