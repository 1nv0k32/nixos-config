{
  config,
  ...
}:
{
  flake.modules.nixos.services-media-server = { config, ... }: {
    users.users.minidlna = {
      extraGroups = [ "users" ];
    };

    systemd.tmpfiles.rules = [ "d /home/media 0775 transmission users" ];

    services = {
      minidlna = {
        enable = true;
        openFirewall = true;
        settings = {
          friendly_name = "${config.networking.hostName} DLNA";
          inotify = "yes";
          notify_interval = 30;
          media_dir = [ "V,/home/media" ];
        };
      };

      transmission = {
        enable = true;
        group = "users";
        openRPCPort = true;
        settings = {
          download-dir = "/home/media";
          rpc-bind-address = "0.0.0.0";
          rpc-whitelist-enabled = false;
          rpc-host-whitelist-enabled = false;
          upload-limit-enabled = true;
          upload-limit = 0;
          speed-limit-up-enabled = true;
          speed-limit-up = 0;
        };
      };
    };
  };
}
