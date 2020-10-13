; Real-Mode Part of the Boot Loader
;
; When the PC starts, the processor is essentially emulating an 8086 processor, i.e. 
; a 16-bit processor.  So our initial boot loader code is 16-bit code that will 
; eventually switch the processor into 32-bit mode.

; ctyme.com/intr/int.htm

BITS 16

; Tell the assembler that we will be loaded at 7C00 (That's where the BIOS loads boot loader code).
ORG 7C00h
start:
	jmp 	Real_Mode_Start				; Jump past our sub-routines


%include "io.asm"

;	Start of the actual boot loader code
Real_Mode_Start:
	cli									; Clear interrupts until the boot process is done
    xor 	ax, ax						; Set stack segment (SS) to 0 and set stack size to top of segment
    mov 	ss, ax
    mov 	sp, 0FFFFh

    mov 	ds, ax						; Set data segment registers (DS and ES) to 0. This means that we will only be dealing 
	mov		es, ax						; with addresses in the first 64K of RAM					
	
	mov 	[boot_device], dl			; Sets boot_device to what the BIOS provides

	mov 	si, boot_message			; Display our greeting
	call 	Console_WriteLine

	; Now we need to read the next part of the boot process into memory

	mov		ah, 2						; BIOS read sector function
	mov		al, 7						; Read 7 sectors
	mov		bx, 9000h					; Load into address ES:BX (0000:9000)
	mov		ch, 0						; Use cylinder 0
	mov		dh, 0						; Use head 0
	mov		dl, [boot_device]			
	mov		cl, 2						; Start reading at sector 2 (one after the boot sector)
	int		13h
	cmp		al, 7						; int 13h (ah:2) returns the number of sectors read in al. If this is not 7, fail.
	jne		Read_Failed

	mov 	dl, [boot_device]			; Pass boot device to second stage
	jmp		9000h						; Jump to stage 2

Read_Failed:
	mov 	si, read_failed_msg
	call	Console_WriteLine

Quit:
	mov		si, cannot_continue_msg
	call	Console_WriteLine

	hlt									; Halt the processor


boot_device:			db	0
boot_message:			db	'Boot Loader V1.1', 0
read_failed_msg:		db	'Unable to read stage 2 of the boot process.', 0
cannot_continue_msg:	db	'Cannot continue boot process.', 0

; Pad out the boot loader so that it will be exactly 512 bytes
	times 510 - ($ - $$) db 0
	
; The segment must end with AA55h to indicate that it is a boot sector
	dw 0AA55h
	