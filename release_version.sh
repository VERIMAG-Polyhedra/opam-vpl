#!/usr/bin/env bash

# Use this script when a new version should be released.
# This script creates a tag for the current master commit of VPL
# with the given version number (argument) and fixes the opam version
# to use this tag.

print_help() {
    echo "Usage: $1 RELEASED_VERSION [-d,--dry-run]"
    echo
    echo "Option -d (or --dry-run) simply prints the commands on the output"
    echo "instead of executing them"
    echo
}

if [ $# -lt 1 ]
then
    print_help "$0"
    exit
else
    RELEASED_VERSION="$1"
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

# Tag the current master (update _oasis files with the new version number)

if $DRY_RUN
then
    echo "("
    echo cd "$TMP_VPL_CLONE"
    if [[ "$RELEASED_VERSION" =~ ^[0-9]+\.[0-9]+$ ]]
    then
        echo sed -i \'s/Version:.*/Version: $RELEASED_VERSION.0/g\' ocaml/_oasis*
    else
        echo sed -i \'s/Version:.*/Version: $RELEASED_VERSION/g\' ocaml/_oasis*
    fi
    echo git commit -am '"Update version number to '$RELEASED_VERSION'"'
    echo git push origin master
    echo git tag -a "$RELEASED_VERSION"
    echo git push origin "$RELEASED_VERSION"
    echo ")"
else
    (
    cd "$TMP_VPL_CLONE"
    if [[ "$RELEASED_VERSION" =~ ^[0-9]+\.[0-9]+$ ]]
    then
        sed -i "s/Version:.*/Version: $RELEASED_VERSION.0/g" ocaml/_oasis*
    else
        sed -i "s/Version:.*/Version: $RELEASED_VERSION/g" ocaml/_oasis*
    fi
    git commit -am "Update version number to $RELEASED_VERSION"
    git push origin master
    git tag -a "$RELEASED_VERSION"
    git push origin "$RELEASED_VERSION"
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
    echo cp -r "packages/vpl-core/vpl-core.0.3" "packages/vpl-core/vpl-core.$RELEASED_VERSION"
    echo echo 'git: "https://github.com/VERIMAG-Polyhedra/vpl#'$RELEASED_VERSION'"' '>' "packages/vpl-core/vpl-core.$RELEASED_VERSION/url"
else
    cp -r "packages/vpl-core/vpl-core.0.3" "packages/vpl-core/vpl-core.$RELEASED_VERSION"
    echo 'git: "https://github.com/VERIMAG-Polyhedra/vpl#'$RELEASED_VERSION'"' > "packages/vpl-core/vpl-core.$RELEASED_VERSION/url"
fi
