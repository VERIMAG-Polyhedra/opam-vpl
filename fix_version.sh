#!/usr/bin/env bash

# Use this script when a new version is prepared
# This script creates a tag for the current master commit of VPL
# with the given version number (argument) and fixes the opam version
# to this tag

# A new package for the next version is created and points to the master
# branch of VPL's git

print_help() {
    echo "Usage: $1 FIXED_VERSION NEXT_VERSION [-d,--dry-run]"
    echo
    echo "Option -d (or --dry-run) simply prints the commands on the output"
    echo "instead of executing them"
    echo
}

if [ $# -lt 2 ]
then
    print_help "$0"
    exit
else
    FIXED_VERSION="$1"
    shift
    NEXT_VERSION="$1"
    shift
fi

DRY_RUN=false

while [ $# -gt 0 ]
do
    case "$1" in
        "-d"|"--dry-run")
            DRY_RUN=true
            ;;
        *)
            print_help "$0"
            exit
            ;;
    esac
    shift
done

VPL_URL="https://github.com/VERIMAG-Polyhedra/VPL"
TMP_VPL_CLONE=/tmp/tmp_vpl

# Remove old tmp clone

if $DRY_RUN
then
    echo rm -rf "$TMP_VPL_CLONE"
else
    rm -rf "$TMP_VPL_CLONE"
fi

# Clone the repository

if $DRY_RUN
then
    echo git clone "$VPL_URL" "$TMP_VPL_CLONE"
else
    git clone "$VPL_URL" "$TMP_VPL_CLONE"
fi

# Tag the current master

if $DRY_RUN
then
    echo "("
    echo cd "$TMP_VPL_CLONE"
    echo git tag -a "$FIXED_VERSION" -m "Version $FIXED_VERSION"
    echo git push origin "$FIXED_VERSION"
    echo ")"
else
    (
    cd "$TMP_VPL_CLONE"
    git tag -a "$FIXED_VERSION" -m "Version $FIXED_VERSION"
    git push origin "$FIXED_VERSION"
    )
fi

# Remove tmp clone

if $DRY_RUN
then
    echo rm -rf "$TMP_VPL_CLONE"
else
    rm -rf "$TMP_VPL_CLONE"
fi

# Update git URL to have permalink to the tagged version

if $DRY_RUN
then
    echo cp -r "packages/vpl-core/vpl-core.$FIXED_VERSION" "packages/vpl-core/vpl-core.$NEXT_VERSION"
    echo echo 'git: "https://github.com/VERIMAG-Polyhedra/vpl#'$FIXED_VERSION'"' '>' "packages/vpl-core/vpl-core.$FIXED_VERSION"
else
    cp -r "packages/vpl-core/vpl-core.$FIXED_VERSION" "packages/vpl-core/vpl-core.$NEXT_VERSION"
    echo 'git: "https://github.com/VERIMAG-Polyhedra/vpl#'$FIXED_VERSION'"' > "packages/vpl-core/vpl-core.$FIXED_VERSION"
fi
