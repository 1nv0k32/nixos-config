{ pkgs, ... }:
{
  shell = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      libcap
      go
      gcc
    ];
  };
}
