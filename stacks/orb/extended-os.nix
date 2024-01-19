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
      ({ config, pkgs, ... }: {
        system.stateVersion = "23.11";

        # users.groups.${config.developer.username} = {
        #   gid = config.developer.gid;
        # };
        # users.users.${config.developer.username} = {
        #   uid = config.developer.uid;
        #   group = config.developer.username;
        #   isNormalUser = true;
        #   extraGroups = [ "wheel" ];
        #   openssh.authorizedKeys.keys = config.developer.sshKeys;
        # };

        environment.systemPackages = with pkgs; [
          vim
          git
        ];
      })
    ] ++ modules;
}
