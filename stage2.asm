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
%include "io.asm"
%include "string.asm"

Stage2:
    mov     si, msg_stage2              ; Print stage 2 message
    call    Console_WriteLine

    call    Enable_A20                  ; Try enabling A20 line, result will be in range 0 (fail) to 4 (1-4 are success values),
    mov     si, dx                      ; we will need to multiply return value by 2 to get an address offset
    shl     si, 1                       
    mov     si, [msg_list + si]
    
    call    Console_WriteLine           ; Print relevant success/fail message

    test    dx, dx                      ; Check for successful activation
    jz      A20_Fail                    ; Halt if failed

    call    Console_Write_CRLF

Input:
    mov     si, cursor
    call    Console_Write_16

    mov     si, i_buff
    call    Console_ReadLine

    ; Integer To String testing
    ;
    ; vv Integer to Decimal string vv
    mov     si, o_buff
    mov     ax, 12345
    call    To_String_Dec

    mov     si, o_buff
    call    Console_WriteLine

    ; vv Integer to Hexadecimal string vv
    mov     si, o_buff
    mov     ax, 0AB12h
    call    To_String_Hex

    mov     si, o_buff
    call    Console_WriteLine
    ;
    ; End of Integer to String testing

    jmp Input

    hlt

A20_Fail:
    hlt                                 ; Could not enable A20 line, halt here

%include "a20msg.asm"

i_buff:     times 7Fh db 0
o_buff:     times 7Fh db 0
cursor:     db "> "

; Pad out the boot loader stage 2 so that it will be exactly 3584 (7 * 512) bytes
	        times 3584 - ($ - $$) db 0