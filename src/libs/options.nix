{ lib, ... }:
{
  options.environment.sysConf = {
    x86 = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    user = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "rick";
        description = "The main user of the system";
      };
      sshPubKeys = lib.mkOption {
        type = lib.types.listOf lib.types.singleLineStr;
        default = [
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILGqq4qABf8hNbaIr2eiKl5GAaLQ0WSVmNlDG+4iW3zRAAAABHNzaDo= rick@nyx"
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPX+my/+qVA9NN/TrX0EU3SLsP2tVgYIh6wSV2GAKQ3iAAAABHNzaDo= rick@nyx"
        ];
        description = "The main user's trusted SSH key";
      };
      yubikeyU2F = lib.mkOption {
        type = lib.types.str;
        default = ''
          Uuvn7svQcdXRQqQ2wCc8RRMAYt5p8huHUTlbEgBzYOVjPnxVxL8JwZaD9GVT0kYWo0k74nYlKIIFyILs4KKOuA==,9vvs3rm0NVl6xq5Ql9Y6TSuYGG69QAHeJCURHLh6fmnEg6aKkZLTNzrBdMwvNMVQF6ij5hjXJGepebMda+/q2Q==,es256,+presence
        '';
      };
    };

    git = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "Armin Mahdilou";
        description = "The name to use for git commits";
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "Armin.Mahdilou@gmail.com";
        description = "The email to use for git commits";
      };
    };

    server = {
      sshPort = lib.mkOption {
        type = lib.types.int;
        default = 2222;
      };
    };
  };
}
