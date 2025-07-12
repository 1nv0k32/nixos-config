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
      sshPubKey = lib.mkOption {
        type = lib.types.str;
        default = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILGqq4qABf8hNbaIr2eiKl5GAaLQ0WSVmNlDG+4iW3zRAAAABHNzaDo= rick@nyx";
        description = "The main user's trusted SSH key";
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
      gpgPubKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "01BE96FB0000FC4AF5587CC5E452EB7AAB80DE7B";
        description = "The default gpg to use for git signing";
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
