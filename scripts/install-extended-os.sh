set -e

# Take arguments from command line
while [ "$#" -gt "0" ]; do
    case "$1" in
        --container-name)
            tmpl_containerName="$2"
            shift 2
            ;;
        --format)
            tmpl_format="$2"
            shift 2
            ;;
        --username)
            tmpl_username="$2"
            shift 2
            ;;
        --uid)
            tmpl_uid="$2"
            shift 2
            ;;
        --gid)
            tmpl_gid="$2"
            shift 2
            ;;
        --ssh-keys)
            tmpl_sshKeys="$2"
            shift 2
            ;;
        *)
            echo "Unknown argument: $1" > /dev/stderr
            exit 1
            ;;
    esac
done

# Make sure all required arguments are set
if [ -z "$tmpl_containerName" ] || [ -z "$tmpl_format" ] || [ -z "$tmpl_username" ] || [ -z "$tmpl_uid" ] || [ -z "$tmpl_gid" ] || [ -z "$tmpl_sshKeys" ]; then
    echo "Missing required argument" > /dev/stderr
    exit 1
fi

nixSystem="$(nix show-config | grep 'system =' | sed 's|system = ||')"

case "$tmpl_format" in
    orb)

cat <<EOF > /etc/nixos/flake.nix
{
  inputs = {
    mrlinux.url = "github:fd/mrlinux";
  };

  outputs = { self, mrlinux }:
    {
      nixosConfigurations.mrlinux = mrlinux.lib.mrlinuxSystem {
        format = "orb";
        system = "$nixSystem";

        modules = [
          # Setup for OrbStack
          ./orbstack.nix
          ./lxd.nix

          # Setup for System
          ./modules/developer.nix
        ];
      };
    };
}
EOF

        ;;
    lxc)

cat <<EOF > /etc/nixos/modules/hostname.nix
{
  networking.hostName = "$tmpl_containerName";
}
EOF

cat <<EOF > /etc/nixos/flake.nix
{
  inputs = {
    mrlinux.url = "github:fd/mrlinux";
  };

  outputs = { self, mrlinux }:
    {
      nixosConfigurations.mrlinux = mrlinux.lib.mrlinuxSystem {
        format = "lxc";
        system = "$nixSystem";

        modules = [
          # Setup for LXC
          ./modules/hostname.nix

          # Setup for System
          ./modules/developer.nix
        ];
      };
    };
}
EOF

        ;;
    *)
        echo "Unsupported format: $tmpl_format" > /dev/stderr
        exit 1
        ;;
esac

# write the /etc/nixos/modules/developer.nix file
cat <<EOF > /etc/nixos/modules/developer.nix
{
  developer = {
    username = "$tmpl_username";
    uid = $tmpl_uid;
    gid = $tmpl_gid;
    sshKeys = [
        $tmpl_sshKeys
    ];
  };
}
EOF

nixos-rebuild switch --flake /etc/nixos#mrlinux
