i686-elf-as ./src/boot.s -o boot.o
i686-elf-gcc -c ./src/kernel/kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
i686-elf-gcc -T ./src/linker.ld -o IcarusOS.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc
if grub-file --is-x86-multiboot IcarusOS.bin; then
  echo multiboot confirmed
else
  echo the file is not multiboot
fi
mkdir -p isodir/boot/grub
cp IcarusOS.bin isodir/boot/IcarusOS.bin
cp grub.cfg isodir/boot/grub/grub.cfg
grub-mkrescue -o IcarusOS.iso isodir
rm IcarusOS.bin
rm kernel.o
rm boot.o


qemu-system-i386 -cdrom IcarusOS.iso