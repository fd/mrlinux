# Getting Started on Darwin

1. Make sure you have OrbStack installed
2. Make sure you have the [`mrlinuxctl`](./mrlinuxctl) script on your system
3. `mrlinuxctl create`
4. `mrlinuxctl code <some project>`
5. From a VS Code terminal, login to Github `gh auth login`

# Getting Started on Linux

1. Make sure LXD is installed and initialized.
2. Make sure you have the [`mrlinuxctl`](./mrlinuxctl) script on your system
3. `mrlinuxctl create`
4. `mrlinuxctl code <some project>`
5. From a VS Code terminal, login to Github `gh auth login`

# Usage

```
mrlinuxctl create [<machine>]
mrlinuxctl delete [<machine>]
mrlinuxctl reset [<machine>]
mrlinuxctl restart [<machine>]
mrlinuxctl code [-m <machine>] [-w|--wait] [-n|--new-window] [-r|--reuse-window] [path...]
```

# Features

- nix
- nix caches
- github integration where needed
- vscode integration
- automatic housekeeping
- keep your personal and professional workspaces separate
