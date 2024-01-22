set -e

# Take arguments from command line
while [ "$#" -gt "0" ]; do
    case "$1" in
        --mrlinux-flake-ref)
            MRLINUX_FLAKE_REF="$2"
            shift 2
            ;;
        --mrlinux-cache-url)
            MRLINUX_CACHE_URL="$2"
            shift 2
            ;;
        --mrlinux-cache-key)
            MRLINUX_CACHE_KEY="$2"
            shift 2
            ;;
        --container-name)
            tmpl_containerName="$2"
            shift 2
            ;;
        --stack)
            tmpl_stack="$2"
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

# Make sure all the mrlinux settings are set
if [ -z "$MRLINUX_FLAKE_REF" ] || [ -z "$MRLINUX_CACHE_URL" ] || [ -z "$MRLINUX_CACHE_KEY" ]; then
    echo "Missing mrlinux settings" > /dev/stderr
    exit 1
fi

# Make sure all required arguments are set
if [ -z "$tmpl_containerName" ] || [ -z "$tmpl_stack" ] || [ -z "$tmpl_username" ] || [ -z "$tmpl_uid" ] || [ -z "$tmpl_gid" ] || [ -z "$tmpl_sshKeys" ]; then
    echo "Missing required argument" > /dev/stderr
    exit 1
fi

export NIX_CONFIG="$(cat <<EOF
experimental-features = nix-command flakes
extra-substituters = ${MRLINUX_CACHE_URL}
extra-trusted-public-keys = ${MRLINUX_CACHE_KEY}
EOF
)"

nixSystem="$(nix show-config | grep 'system =' | sed 's|system = ||')"
mkdir -p /etc/nixos/modules

case "$tmpl_stack" in
    orb)

cat <<EOF > /etc/nixos/flake.nix
{
  inputs = {
    mrlinux.url = "$MRLINUX_FLAKE_REF";
  };

  outputs = { self, mrlinux }:
    {
      nixosConfigurations.$tmpl_containerName = mrlinux.lib.mrlinuxSystem {
        stack = "orb";
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
    mrlinux.url = "$MRLINUX_FLAKE_REF";
  };

  outputs = { self, mrlinux }:
    {
      nixosConfigurations.$tmpl_containerName = mrlinux.lib.mrlinuxSystem {
        stack = "lxc";
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
        echo "Unsupported stack: $tmpl_stack" > /dev/stderr
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

nixos-rebuild switch --flake /etc/nixos#$tmpl_containerName
