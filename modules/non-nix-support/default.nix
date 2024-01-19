# This module enables support for non-nix binaries like VSCode.
{ pkgs, ... }:
{
  # Dynamic linker magic to make non-nix binaries work.
  programs.nix-ld = {
    enable = true;
    # We use nix-ld-rs as it doesn't leak the LD_LIBRARY_PATH environment variable
    # to child processes. This makes the VSCode shell much more usable.
    # 
    # See: https://github.com/nix-community/nix-ld-rs
    package = pkgs.nix-ld-rs;
  };
}
