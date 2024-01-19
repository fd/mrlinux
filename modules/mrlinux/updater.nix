{ pkgs, ... }:
{

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "do-update-mrlinux"
      ''
        set -e
        nix flake update /etc/nixos
        nixos-rebuild switch
      '')
  ];

}
