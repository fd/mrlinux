{ config, ... }:
{
  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  nix.settings.trusted-users = [ "root" config.developer.username ];
}
