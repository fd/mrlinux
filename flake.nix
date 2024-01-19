{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nix-ld-rs.url = "github:nix-community/nix-ld-rs";
  };

  outputs = { self, nixpkgs, nix-ld-rs }:
    (
      let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };

        base-os = import ./stacks/lxc/base-os.nix { inherit nixpkgs pkgs; };

        lxc-import-image = pkgs.writeShellScriptBin "lxc-import-image"
          ''
            set -e
            exec lxc image import \
              ${self.packages.${system}.lxc-metadata}/tarball/nixos-system-x86_64-linux.tar.xz \
              ${self.packages.${system}.lxc}/tarball/nixos-system-x86_64-linux.tar.xz \
              --alias mrlinux
          '';
      in
      {
        packages.x86_64-linux = {
          lxc = base-os.config.system.build.tarball;
          lxc-metadata = base-os.config.system.build.metadata;
          lxc-import-image = lxc-import-image;

          install-extended-os = pkgs.writeShellScriptBin "install-extended-os" (builtins.readFile ./scripts/install-extended-os.sh);

          dummy-system-for-cache = (self.lib.mrlinuxSystem {
            format = "lxc";
            system = system;
            modules = [
              {
                networking.hostName = "mrlinux";
                developer = {
                  username = "dummy";
                  uid = 1000;
                  gid = 1000;
                  sshKeys = [
                    "ssh-ed25519 AAAAC"
                  ];
                };
              }
            ];
          }).config.system.build.toplevel;
        };
      }
    ) // {
      lib.mrlinuxSystem = { format, system, modules }:
        assert (builtins.typeOf format) == "string";
        assert (builtins.typeOf system) == "string";
        assert (builtins.typeOf modules) == "list";
        import ./stacks/${format}/extended-os.nix {
          inherit nixpkgs modules;

          pkgs = import nixpkgs {
            inherit system;
            overlays = [ nix-ld-rs.overlays.default ];
          };
        };
    };
}
