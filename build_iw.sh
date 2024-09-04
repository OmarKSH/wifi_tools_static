#!/bin/sh
set -e

iw_url="https://kernel.org/pub/software/network/iw"
iw_txz="$(wget -O - $iw_url | grep '.xz' | cut -d'>' -f2 | cut -d'<' -f1 | sort | tail -1)"
iw_url="$iw_url/$iw_txz"
iw_dir="${iw_txz%.tar.xz}"

prefix="`pwd`/prefix"
binaries="`pwd`/binaries"

# fetch source code archive
[ -f "$iw_txz" ]    || wget "$iw_url"

# unpack source files
[ -d "$iw_dir"    ] || tar xf "${iw_txz}"

# build iw
if ! [ -f "${iw_dir}/iw" ] ; then
    cd "$iw_dir"
    (
	export PKG_CONFIG_PATH="${prefix}/lib/pkgconfig"
	make -j`nproc --all` V=1 LDFLAGS+='-static'
    # binaries output directory
    [ -d "$binaries" ] || mkdir $binaries

    cp iw "$binaries/"
    strip -s "$binaries/iw"
    )
fi

echo "iw has been compiled. Executable placed in $binaries"
