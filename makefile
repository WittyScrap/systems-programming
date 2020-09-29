# Create the boot loader binaries

.DEFAULT_GOAL:=bootloader.img

.SUFFIXES: .img .bin .asm .sys .o .lib
.PRECIOUS: %.o

QEMUOPTS = -drive file=bootloader.img,index=0,media=disk,format=raw -smp 1 -m 512 $(QEMUEXTRA)

%.bin: %.asm
	nasm -w+all -f bin -o $@ $<
	
boot.bin: boot.asm 

bootloader.img: boot.bin 
	dd if=/dev/zero of=bootloader.img count=10000
	dd if=boot.bin of=bootloader.img conv=notrunc

qemu: bootloader.img 
	qemu-system-i386 -serial mon:stdio $(QEMUOPTS)

# try to generate a unique GDB port
GDBPORT = $(shell expr `id -u` % 5000 + 25000)
# QEMU's gdb stub command line changed in 0.11
QEMUGDB = $(shell if qemu-system-i386 -help | grep -q '^-gdb'; \
	then echo "-gdb tcp::$(GDBPORT)"; \
	else echo "-s -p $(GDBPORT)"; fi)

qemu-gdb: bootloader.img 
	qemu-system-i386 -serial mon:stdio $(QEMUOPTS) -S $(QEMUGDB)

clean:
	rm -f boot.bin
	rm -f bootloader.img
	
	