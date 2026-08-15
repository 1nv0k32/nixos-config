{
  pkgs,
  ...
}:
{
  flake.modules.nixos.programs-wireshark = { pkgs, ... }: {
    programs = {
      wireshark = {
        enable = true;
        package = pkgs.wireshark;
      };
    };
  };
}
