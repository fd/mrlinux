{ pkgs, nixpkgs, modules }:
nixpkgs.lib.nixosSystem {
  inherit pkgs;
  modules =
    [
      ../../modules/lxc.nix
      ../../modules/nix/housekeeping.nix
      ../../modules/nix/settings.nix
      ../../modules/non-nix-support/default.nix
      ../../modules/developer.nix
      ../../modules/basictools.nix
      ../../modules/mrlinux/updater.nix
      ({ config, pkgs, ... }: {
        system.stateVersion = "23.11";

        environment.variables = {
          GH_BROWSER = "x-www-browser";
        };

        environment.systemPackages = [
          # Install the _open a browser_ tools
          (pkgs.writeShellScriptBin "x-www-browser" ''
            echo "Opening $@" > /dev/stderr
            exec mac open "$@"
          '')
        ];
      })
    ] ++ modules;
}
