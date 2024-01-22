{
  imports = [
    ./nix/housekeeping.nix
    ./nix/settings.nix
    ./non-nix-support/default.nix
    ./developer.nix
    ./basictools.nix
    ./mrlinux/updater.nix
    ./mrlinux/options.nix
    ./oci-containers.nix
  ];
}
