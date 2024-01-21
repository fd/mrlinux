{ pkgs, nixpkgs, modules }:
nixpkgs.lib.nixosSystem {
  inherit pkgs;
  modules =
    [
      ({ modulesPath, ... }: {
        imports = [ "${toString modulesPath}/virtualisation/lxc-container.nix" ];
      })
      ../../modules
      ({ config, pkgs, ... }: {
        system.stateVersion = "23.11";

        # sudoers
        security.sudo.extraRules = [
          {
            users = [ config.developer.username ];
            commands = [
              {
                command = "ALL";
                options = [ "NOPASSWD" ];
              }
            ];
          }
        ];

        users.groups.${config.developer.username} = {
          gid = config.developer.gid;
        };
        users.users.${config.developer.username} = {
          uid = config.developer.uid;
          group = config.developer.username;
          isNormalUser = true;
          extraGroups = [ "wheel" ];
          openssh.authorizedKeys.keys = config.developer.sshKeys;
        };

        networking.firewall.allowedTCPPorts = [ 22 ];
        services.openssh = {
          enable = true;
          settings.PasswordAuthentication = false;
        };
      })
    ] ++ modules;
}
