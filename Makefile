OBJECTS = kernel/loader.o kmain.o 
CC = gcc
CFLAGS = -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector \
		 -nostartfiles -nodefaultlibs -Wall -Wextra -Werror -c
LDFLAGS = -T external/link.ld -melf_i386
AS = nasm
ASFLAGS = -f elf

all: kernel.elf

kernel.elf: 
	$(AS) $(ASFLAGS) kernel/loader.asm 
	$(CC) $(CFLAGS) kernel/kmain.c
	ld $(LDFLAGS) $(OBJECTS) -o kernel.elf

os.iso: kernel.elf
	mkdir -p iso/boot/grub
	cp external/* iso/boot/grub
	cp kernel.elf iso/boot/
	genisoimage -R                              \
				-b boot/grub/stage2_eltorito    \
                -no-emul-boot                   \
                -boot-load-size 4               \
                -A os                           \
                -input-charset utf8             \
                -quiet                          \
                -boot-info-table                \
                -o os.iso                       \
                iso

run: os.iso
	qemu-system-x86_64 -boot d -cdrom os.iso -m 512	

clean:
	rm -rf boot/*.o kernel/*.o *.o kernel.elf os.iso iso
