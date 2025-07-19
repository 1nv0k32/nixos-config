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
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAINmmAvTaZ5rRNhY0mnX2UzUCX5pRX0DX+VCEBxCXbX9sAAAABnNzaDo1Yw== rick@nyx" # 5c
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICjS+ZPa4qUA+Vm0C7Br8PJ/U1Z9dh6bXcXZdko3ZFz9AAAAB3NzaDpiaW8= rick@nyx" # bio
        ];
        description = "The main user's trusted SSH key";
      };
      yubikeyU2F = lib.mkOption {
        type = lib.types.str;
        default =
          let
            key_5c = "qJzOdjN/bRt9nqlPPpT3ULxN0omg9EgvhpiIc5/xeqY5dQrk+K2Sc6IGYqIXne3oWV9usY/pq6gxfTom42DtGg==,+HdbjR3Pp5SAhRiDFSkIiUWCtpTHv81c9fV7aNcnUdaiKVWMQbFsgpqsPsG0MG3dx76bCjB1QhOKxv6k7V4+QQ==,es256,";
            key_bio = "7wwRJCaiRcL/HwR8JK7hdITpvcsX55jKDtY7ckBhUB00p8Id2s5AykzVPq79dbKvkiQhhcrQvd3bT1w3x16Nyw==,ijaKeTEL3VG81mm+0zi0XxZe8uXbcR8j8Rr/oZZGn3FbpTlWm+5wRyYjx0hPz02Ve8QyspXg935VnHl8lRMahw==,es256,+presence";
          in
          ''
            ${key_5c}:${key_bio}
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
