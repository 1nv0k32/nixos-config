{ config, ... }:
{
  services.gitea = {
    enable = true;
    settings = {
      server.HTTP_ADDR = "127.0.0.1";
      server.HTTP_PORT = 3000;
      server.SSH_PORT = config.environment.sysConf.server.sshPort;
      server.DOMAIN = "git.${config.networking.domain}";
      webhook.ALLOWED_HOST_LIST = "*";
    };
  };

  networking.firewall.allowedTCPPorts = [
    8080
    4433
  ];

  services.nginx = {
    enable = true;
    defaultHTTPListenPort = 8080;
    defaultSSLListenPort = 4433;
    virtualHosts = {
      "git.${config.networking.domain}" = {
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
