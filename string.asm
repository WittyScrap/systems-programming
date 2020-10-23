; Converts a number to a base-10 string representation.
;
; INPUT: SI points to a preallocated output buffer.
;        AX contains the number to be converted.
; OUTPUT: Final string will be stored in the buffer pointed to by SI.
To_String_Dec:
    mov     cx, 10
    mov     bp, sp

To_String_Dec_Next:
    xor     dx, dx
    div     cx
    add     dx, '0'
    push    dx
    test    ax, ax
    jnz     To_String_Dec_Next

To_String_Dec_Write:
    pop     ax
    mov     [si], al
    add     si, 1
    cmp     bp, sp
    jne     To_String_Dec_Write
    mov     byte[si], 0

    ret


; Converts a number to a 4-digit base-16 string representation and prints it.
;
; INPUT: BX contains the 16-bit input number to be converted.
Console_WriteHex:
    mov     cx, 4
    mov     ah, 0Eh

Console_WriteHex_Loop:
    mov     si, 0Fh
    rol     bx, 4
    and     si, bx
    mov     al, [HEX_ASCII + si]
    int     10h
    loop    Console_WriteHex_Loop

    ret


; Converts a number to a 4-digit base-16 string representation.
;
; INPUT: SI points to an allocated output buffer.
;        AX contains the 16-bit input number to be converted.
; OUTPUT: Final string will be stored in the buffer pointed to by SI.
To_String_Hex:
    add     si, 3

To_String_Hex_Next:
    mov     di, 0Fh
    and     di, ax
    mov     cl, [HEX_ASCII + di]
    mov     [si], cl
    sub     si, 1
    shr     ax, 4
    jnz     To_String_Hex_Next
    mov     byte[si + 4], 0

    ret


; Hex chars LUT
HEX_ASCII:      db "0123456789ABCDEF"