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

# Note that both targets qemu and qemu-gdb require that an XServer is running
# On the virtual machines used for this module, VcXsrv runs on startup of the VM

qemu: bootloader.img 
	qemu-system-i386 -serial mon:stdio $(QEMUOPTS)

qemu-gdb: bootloader.img 
	@echo "*** Now run 'gdb'." 1>&2
	qemu-system-i386 -serial mon:stdio $(QEMUOPTS) -S -s 
	

clean:
	rm -f boot.bin
	rm -f bootloader.img
	
	