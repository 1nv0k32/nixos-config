{
  inputs,
  ...
}:
{
  flake.modules.nixos.hardware-mac = { lib, ... }: {
    imports = [
      inputs.nixos-mac.nixosModules.apple-silicon-support
    ];

    hardware.asahi = {
      enable = true;
      extractPeripheralFirmware = lib.mkDefault false;
    };

    boot = {
      extraModprobeConfig = ''
        options hid_apple fnmode=3 iso_layout=-1 swap_opt_cmd=1
      '';
      loader.efi.canTouchEfiVariables = false;
    };

    networking.networkmanager.enable = true;
  };
}
