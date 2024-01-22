{ lib, config, ... }:
with lib;
let
  cfg = config.developer;
in
{
  options.developer = {
    username = mkOption {
      type = types.nonEmptyStr;
      example = "johndoe";
      description =
        ''
          The username of the developer.
          This value should match the host.
        '';
    };

    uid = mkOption {
      type = types.int;
      example = 1000;
      description =
        ''
          The UID of the developer.
          This value should match the host.
        '';
    };

    gid = mkOption {
      type = types.int;
      example = 1000;
      description =
        ''
          The GID of the developer.
          This value should match the host.
        '';
    };

    sshKeys = mkOption {
      type = types.nonEmptyListOf types.nonEmptyStr;
      example = [ "ssh-ed25519 AA..." ];
      description =
        ''
          The SSH public keys used by the developer.
          This value should match the host.
        '';
    };

    configPath = mkOption {
      type = types.nonEmptyStr;
      readOnly = true;
      description =
        ''
          The path to the developer configuration diectory.
          This value is set by the stack.
        '';
    };
  };
}
