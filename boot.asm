; Real-Mode Part of the Boot Loader
;
; When the PC starts, the processor is essentially emulating an 8086 processor, i.e. 
; a 16-bit processor.  So our initial boot loader code is 16-bit code that will 
; eventually switch the processor into 32-bit mode.

BITS 16

; Tell the assembler that we will be loaded at 7C00 (That's where the BIOS loads boot loader code).
ORG 7C00h
start:
	jmp 	Real_Mode_Start				; Jump past our sub-routines

	; Write to the console using BIOS.
; 
; Input: SI points to a null-terminated string

Console_Write_16:
	mov 	ah, 0Eh						; 0Eh is the INT 10h BIOS call to output the value contained in AL to screen

Console_Write_16_Repeat:
    mov		al, [si]					; Load the byte at the location contained in the SI register into AL
	inc     si							; Add 1 to SI
    test 	al, al						; If the byte is 0, we are done
	je 		Console_Write_16_Done
	int 	10h							; Output character contained in AL to screen
	jmp 	Console_Write_16_Repeat		; and get the next byte

Console_Write_16_Done:
    ret


;	Start of the actual boot loader code
	
Real_Mode_Start:
	cli									; Clear interrupts until the boot process is done
    xor 	ax, ax						; Set stack segment (SS) to 0 and set stack size to top of segment
    mov 	ss, ax
    mov 	sp, 0FFFFh

    mov 	ds, ax						; Set data segment registers (DS and ES) to 0. This means that we will only be dealing 
	mov		es, ax						; with addresses in the first 64K of RAM					
	
	mov 	si, boot_message			; Display our greeting
	call 	Console_Write_16

	hlt									; Halt the processor					

boot_message:		db	'Boot Loader V1.0', 0

; Pad out the boot loader so that it will be exactly 512 bytes
	times 510 - ($ - $$) db 0
	
; The segment must end with AA55h to indicate that it is a boot sector
	dw 0AA55h
	