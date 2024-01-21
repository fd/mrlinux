{ pkgs, nixpkgs }:
nixpkgs.lib.nixosSystem {
  inherit pkgs;
  modules =
    [
      ({ modulesPath, ... }: {
        imports = [ "${toString modulesPath}/virtualisation/lxc-container.nix" ];
      })
      {
        system.stateVersion = "23.11";
      }
    ];
}
