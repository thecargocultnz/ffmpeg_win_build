#!/bin/bash

package_variant() {
    IN="$1"
    OUT="$2"

    mkdir -p "$OUT"/bin
    if compgen -G "$IN/bin/*.exe" > /dev/null; then
        cp "$IN/bin/"*.exe "$OUT/bin"
    fi
    cp "$IN/bin/"*.dll "$OUT/bin"

    mkdir -p "$OUT"/lib
    cp "$IN"/bin/*.lib "$OUT"/lib
    cp "$IN"/lib/*.{def,dll.a} "$OUT"/lib

    mkdir -p "$OUT"/lib/pkgconfig
    cp -a "$IN"/lib/pkgconfig/*.pc "$OUT"/lib/pkgconfig
    sed -i \
        -e 's|^prefix=.*|prefix=${pcfiledir}/../..|' \
        -e 's|/ffbuild/prefix|${prefix}|' \
        -e '/Libs.private:/d' \
        "$OUT"/lib/pkgconfig/*.pc

    mkdir -p "$OUT"/include
    cp -r "$IN"/include/* "$OUT"/include

    mkdir -p "$OUT"/doc
    cp -r "$IN"/share/doc/ffmpeg/* "$OUT"/doc
}
