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
Print_String_Hex:
    mov     cx, 4
    mov     ah, 0Eh

Print_String_Hex_Next:
    mov     si, 0Fh
    rol     bx, 4
    and     si, bx
    mov     al, [HEX_ASCII + si]
    int     10h
    loop    Print_String_Hex_Next

    ret


; Converts a number to a 4-digit base-16 string representation.
;
; INPUT: SI points to an allocated output buffer.
;        AX contains the 16-bit input number to be converted.
; OUTPUT: Final string will be stored in the buffer pointed to by SI.
To_String_Hex:
    mov     bx, -4

To_String_Hex_Next:
    mov     di, 0Fh
    rol     ax, 4
    and     di, ax
    mov     al, [HEX_ASCII + di]
    mov     [si + bx + 4], cl
    add     bx, 1
    jnz     To_String_Hex_Next
    mov     byte[si + 4], 0

    ret


; Hex chars LUT
HEX_ASCII:      db "0123456789ABCDEF"