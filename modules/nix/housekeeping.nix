# This module contains the houkeeping tasks for Nix.
{ ... }:
{
  # Do a full GC of the Nix Store once every week
  nix.gc = {
    automatic = true;
    dates = "Mon *-*-* 03:00:00";
  };

  # Optimise the Nix Store once every day.
  nix.optimise = {
    automatic = true;
    dates = [ "04:00:00" ];
  };
}
