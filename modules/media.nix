{ ... }:
{
  users.users.minidlna = {
    extraGroups = [ "users" ];
  };

  services = {
    minidlna = {
      enable = true;
      openFirewall = true;
      settings = {
        friendly_name = "nyxpi DLNA MEDIA";
        inotify = true;
        media_dir = [ "V,/data/movies/" ];
      };
    };
  };
}
