{ modulesPath, options, ... }:
let
  mainUser = "rick";
in
{
  virtualisation.vmVariant = {
    imports = [
      (modulesPath + "/virtualisation/qemu-vm.nix")
    ];

    virtualisation = {
      memorySize = 8192;
      cores = 6;
    };

    users.users."${mainUser}".initialPassword = mainUser;
    boot.kernelParams = options.boot.kernelParams.default ++ [ "console=ttyS0,115200" ];

    networking = {
      hostName = "vmnix";
      firewall = {
        allowPing = true;
        allowedTCPPorts = options.networking.firewall.allowedTCPPorts.default ++ [ 22 ];
      };
    };

    services = {
      k3s.enable = true;
      qemuGuest.enable = true;
      openssh.enable = true;
    };
  };
}

# vim:expandtab ts=2 sw=2
