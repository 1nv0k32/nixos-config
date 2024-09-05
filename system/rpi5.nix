{ pkgs, lib, ... }:
with lib;
{
  nixpkgs.buildPlatform.system = "x86_64-linux";
  nixpkgs.hostPlatform.system = "aarch64-linux";
}
