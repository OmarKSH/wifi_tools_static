#!/bin/sh
set -e

hostapd_url="https://www.w1.fi/releases"
hostapd_tgz="$(wget -O - $hostapd_url | grep -E '>hostapd-[0-9.]+.tar.gz<' | cut -d'>' -f7 | cut -d'<' -f1 | sort | tail -1)"
hostapd_url="$hostapd_url/$hostapd_tgz"
hostapd_dir="${hostapd_tgz%.tar.gz}"

prefix="`pwd`/prefix"
binaries="`pwd`/binaries"

# fetch source code archive
[ -f "$hostapd_tgz" ] || wget $hostapd_url

# unpack source files
[ -d "$hostapd_dir"   ] || tar xf "${hostapd_tgz}"

# set hostapd build configuration
cp hostapd_build_config "$hostapd_dir/hostapd/.config"

# build hostapd
if ! [ -f "${hostapd_dir}/hostapd/wpa_supplicant" ] ; then
    cd "$hostapd_dir/hostapd/"
    (
    make -j`nproc --all` LDFLAGS+="-static"
    # binaries output directory
    [ -d "$binaries" ] || mkdir $binaries

    cp hostapd "$binaries/"
    cp hostapd_cli "$binaries/"
    strip -s "$binaries/hostapd"
    strip -s "$binaries/hostapd_cli"
    )
fi

echo "hostapd has been compiled. Executables placed in $binaries"
