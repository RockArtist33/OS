#!/bin/sh
set -e
. ./build.sh

mkdir -p isodir
mkdir -p isodir/boot
mkdir -p isodir/boot/grub

cp sysroot/boot/icarusos.kernel isodir/boot/icarusos.kernel
cat > isodir/boot/grub/grub.cfg << EOF
menuentry "icarusos" {
	multiboot /boot/icarusos.kernel
}
EOF
grub-mkrescue -o icarusos.iso isodir
