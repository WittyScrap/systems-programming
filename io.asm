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


; Write to the console using BIOS.
; Appends a CRLF to the end of the string.
;
; Input: SI points to a null-terminated string
Console_WriteLine:
	mov 	ah, 0Eh

Console_WriteLine_Repeat:
	mov 	al, [si]
	add		si, 1
	test	al, al
	je 		Console_Write_CRLF
	int		10h
	jmp 	Console_WriteLine_Repeat

; Prints a CRLF combination
Console_Write_CRLF:
	mov		ah, 0Eh
	mov		al, 0Dh
	int		10h
	mov		al, 0Ah
	int		10h
	ret