; Real-Mode Part of the Boot Loader
;
; When the PC starts, the processor is essentially emulating an 8086 processor, i.e. 
; a 16-bit processor.  So our initial boot loader code is 16-bit code that will 
; eventually switch the processor into 32-bit mode.

; ctyme.com/intr/int.htm

BITS 16

; Tell the assembler that we will be loaded at 9000h (That's where stage 1 jumps to to begin stage 2).
ORG 9000h
start:
    jmp     Stage2                      ; Startup

%include "a20.asm"

Stage2:
    hlt                                 ; Why even try

; Pad out the boot loader stage 2 so that it will be exactly 3584 (7 * 512) bytes
	times 3584 - ($ - $$) db 0