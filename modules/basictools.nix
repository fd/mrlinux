{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    git
    htop
    jq
    dig
  ];
}
