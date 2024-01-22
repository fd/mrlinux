# Setup for Podman and Docker compat
# 
# We only do this for the LXC stack as the Orb stack 
# already has docker.
{ pkgs, lib, config, ... }:
{
  config = lib.mkIf (config.mrlinux.stack == "lxc") {
    environment.systemPackages = with pkgs; [
      podman-compose
    ];

    virtualisation = {
      podman = {
        enable = true;

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
