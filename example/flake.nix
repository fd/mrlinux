{
  inputs = {
    mrlinux.url = "path:..";
  };

  outputs = { self, mrlinux }:
    {
      nixosConfigurations.mrlinux = mrlinux.lib.mrlinuxSystem {
        format = "lxc";
        system = "x86_64-linux";

        modules = [
          # Setup for LXC
          ./modules/hostname.nix

          # Setup for System
          ./modules/developer.nix
        ];
      };

      # nixosConfigurations.mrlinux-orbstack = mrlinux.lib.mrlinuxSystem {
      #   format = "orb";
      #   system = "x86_64-linux";

      #   modules = [
      #     # Setup for OrbStack
      #     /etc/nixos/orbstack.nix
      #     /etc/nixos/lxd.nix

      #     # Setup for System
      #     ./modules/developer.nix
      #   ];
      # };
    };
}
