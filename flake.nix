{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    attic.url = "github:zhaofengli/attic";

    nix-ld-rs.url = "github:nix-community/nix-ld-rs";
  };

  outputs = { self, nixpkgs, flake-utils, devshell, attic, nix-ld-rs }:
    (flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            devshell.overlays.default
            attic.overlays.default
          ];
        };

        base-os = import ./stacks/lxc/base-os.nix { inherit nixpkgs pkgs; };

        lxc-import-image = pkgs.writeShellScriptBin "lxc-import-image"
          ''
            set -e
            exec lxc image import \
              ${self.packages.${system}.lxc-metadata}/tarball/nixos-system-x86_64-linux.tar.xz \
              ${self.packages.${system}.lxc}/tarball/nixos-system-x86_64-linux.tar.xz \
              --alias mrlinux
          '';

        releasePackages = pkgs.runCommandNoCC "release-packages"
          {
            packages = [ ]
            ++ (builtins.attrValues (builtins.removeAttrs self.packages."x86_64-linux" [ "release-packages" ]))
            ++ (builtins.attrValues (builtins.removeAttrs self.packages."aarch64-linux" [ "release-packages" ]));
          }
          ''
            set -e
            mkdir -p $out
            for p in $packages; do
              ln -s $p $out/$(basename $p)
            done
          '';
      in
      {
        checks = self.packages.${system} // {
          devshell = self.devShells.${system}.default;
        };

        packages = {
          release-packages = releasePackages;

          # LXC base OS
          lxc = base-os.config.system.build.tarball;
          lxc-metadata = base-os.config.system.build.metadata;
          lxc-import-image = lxc-import-image;

          # Used by the installer
          install-extended-os = pkgs.writeShellScriptBin "install-extended-os" (builtins.readFile ./scripts/install-extended-os.sh);

          dummy-extended-lxc = (self.lib.mrlinuxSystem {
            stack = "lxc";
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

          dummy-extended-orb = (self.lib.mrlinuxSystem {
            stack = "orb";
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

        devShells.default = pkgs.devshell.mkShell ({ config, ... }: {
          commands = [
            {
              help = "Push release artifacts to our public attic cache";
              name = "do-push-release";
              command = ''
                ${pkgs.attic-client}/bin/attic push alpha:release-public \
                  $(nix build .#packages.x86_64-linux.release-packages --no-link --print-out-paths) \
                  $(nix build .#packages.aarch64-linux.release-packages --no-link --print-out-paths)
              '';
            }
          ];
        });

      }))
    // {
      lib.mrlinuxSystem = { stack, system, modules }:
        assert (builtins.typeOf stack) == "string";
        assert (builtins.typeOf system) == "string";
        assert (builtins.typeOf modules) == "list";
        import ./stacks/${stack}/extended-os.nix {
          inherit nixpkgs modules;

          pkgs = import nixpkgs {
            inherit system;
            overlays = [ nix-ld-rs.overlays.default ];
          };
        };
    };
}
