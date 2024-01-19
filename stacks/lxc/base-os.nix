{ pkgs, nixpkgs }:
nixpkgs.lib.nixosSystem {
  inherit pkgs;
  modules =
    [
      ../../modules/lxc.nix
      {
        system.stateVersion = "23.11";
      }
    ];
}
