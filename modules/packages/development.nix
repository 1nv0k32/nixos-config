{
  pkgs,
  ...
}:
{
  flake.modules.nixos.packages-development = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      kubernetes-helm
      k9s
      argocd
      opentofu
      podman-compose
      kind
      k3d
      istioctl
      cilium-cli
      talosctl
      openstackclient-full
      distrobox
      quickemu
      android-tools
    ];
  };
}
