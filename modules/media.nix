{ ... }:
let
  media_dir = "/data/movies/";
in
{
  # users.users.minidlna = {
  #   extraGroups = [ "users" ];
  # };

  services = {
    # minidlna = {
    #   enable = true;
    #   openFirewall = true;
    #   settings = {
    #     friendly_name = "nyxpi DLNA MEDIA";
    #     inotify = "yes";
    #     media_dir = [ "V,${media_dir}" ];
    #   };
    # };

    transmission = {
      enable = true;
      settings = {
        download-dir = media_dir;
        rpc-bind-address = "0.0.0.0";
        upload-limit-enabled = true;
        upload-limit = 0;
      };
    };
  };
}
