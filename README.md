https://ubuntu.com/server/docs/containers-lxc
https://ubuntu.com/blog/nested-containers-in-lxd
https://nixos.org/manual/nixos/stable/#ch-containers
https://systemd.io/CONTAINER_INTERFACE/

```sh
# Install lxd
snap install lxd
lxd init # choose all the defaults

# Import base-os
nix run .#lxc-import-image

# Create a container
lxc init mrlinux t1 -c security.nesting=true
lxc config device add t1 host-home disk source=/home/fd path=/host/home/fd shift=true readonly=true
lxc config device add t1 user-src disk source=/home/fd/src path=/home/fd/src shift=true

# lxc exec t1  -- /bin/sh -li
lxc exec t1  -- nixos-rebuild switch --flake .#mrlinux
# sudo nixos-rebuild switch --flake .#mrlinux

code --remote ssh-remote+$USER@10.117.224.169
```

# Flow

1. build base lxc NixOS
2. create lxc instance
3. switch to extended lxc NixOS
