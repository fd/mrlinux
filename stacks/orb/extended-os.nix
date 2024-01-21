{ pkgs, nixpkgs, modules }:
nixpkgs.lib.nixosSystem {
  inherit pkgs;
  modules =
    [
      # Import the LXC container module
      ({ modulesPath, ... }: {
        imports = [ "${toString modulesPath}/virtualisation/lxc-container.nix" ];
      })
      # Import the Extended OS
      ../../modules
      # Import the Stack specific configuration
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
