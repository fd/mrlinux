{ lib, config, ... }:
with lib;
let
  cfg = config.mrlinux;
in
{
  options.mrlinux = {
    stack = mkOption {
      type = types.nonEmptyStr;
      example = "lxc";
      description =
        ''
          The type of stack this system is on.
        '';
    };
  };
}
