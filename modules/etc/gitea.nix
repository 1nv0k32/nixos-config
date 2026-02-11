{ config, ... }:
{
  services.gitea = {
    enable = true;
    settings = {
      server.HTTP_ADDR = "127.0.0.1";
      server.HTTP_PORT = 3000;
      server.DOMAIN = "${config.networking.fqdn}";
      webhook.ALLOWED_HOST_LIST = "*";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "git.${config.networking.fqdn}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          extraConfig = ''
            client_max_body_size 512M;
            proxy_set_header Connection $http_connection;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
  };
}
