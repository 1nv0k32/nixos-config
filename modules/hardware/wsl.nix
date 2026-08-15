{
  inputs,
  ...
}:
{
  flake.modules.nixos.hardware-wsl = { config, lib, pkgs, ... }: {
    imports = [
      inputs.nixos-wsl.nixosModules.wsl
    ];

    wsl = {
      enable = true;
      startMenuLaunchers = true;
      defaultUser = config.environment.sysConf.user.name;
      extraBin = with pkgs; [
        { src = "${lib.getExe wget}"; }
        { src = "${lib.getExe curl}"; }
      ];
      wslConf = {
        user.default = config.environment.sysConf.user.name;
        boot.systemd = true;
      };
    };

    programs = {
      nix-ld = {
        enable = true;
        libraries = with pkgs; [
          libgcc
          zlib
          pcre2
        ];
      };
    };

    services.resolved.enable = lib.mkForce false;
    boot = {
      loader.systemd-boot.enable = lib.mkForce false;
      initrd.systemd.enable = lib.mkForce false;
      binfmt.emulatedSystems = lib.mkForce [ ];
    };
  };
}
