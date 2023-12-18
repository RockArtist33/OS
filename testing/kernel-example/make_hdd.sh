export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

make
rm image.hdd

# Create an empty zeroed-out 64MiB image file.
dd if=/dev/zero bs=1M count=0 seek=64 of=image.hdd
 
# Create a GPT partition table.
sgdisk image.hdd -n 1:2048 -t 1:ef00
 
# Download the latest Limine binary release.
git clone https://github.com/limine-bootloader/limine.git --branch=v6.x-branch-binary --depth=1
 
# Build limine utility.
make -C limine
 
# Install the Limine BIOS stages onto the image.
./limine/limine bios-install image.hdd
 
# Format the image as fat32.
mformat -i image.hdd@@1M
 
# Make /EFI and /EFI/BOOT an MSDOS subdirectory.
mmd -i image.hdd@@1M ::/EFI ::/EFI/BOOT
 
# Copy over the relevant files
mcopy -i image.hdd@@1M bin/icarusos limine.cfg limine/limine-bios.sys ::/
mcopy -i image.hdd@@1M limine/BOOTX64.EFI ::/EFI/BOOT
mcopy -i image.hdd@@1M limine/BOOTIA32.EFI ::/EFI/BOOT

qemu-system-x86_64 image.hdd