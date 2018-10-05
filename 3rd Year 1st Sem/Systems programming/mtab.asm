;macro to print new line
new_line macro
	mov ah,02h
	mov dl,0dh
	int 21h
	mov dl,0ah
	int 21h
endm

;macro to print space
space macro
	mov ah,02h
	mov dl,' '
	int 21h
endm

;macro to print a message
printm macro mess
	lea dx,mess
	mov ah,09h
	int 21h
endm

;macro to exit
exitp macro
	mov ah,4ch
	int 21h
endm

; macro for decimal input
dec_input macro
	local input,skip
	; output: bx

	xor bx,bx

	mov ah,01h
	int 21h

	;if \r
	cmp al,0dh
	je skip

	input:
		and ax,000fh

		push ax

		; bx=bx*10+ax
		mov ax,10
		mul bx
		mov bx,ax

		pop ax

		add bx,ax
		; take input
		mov ah,01h
		int 21h

		cmp al,0dh
		jne input

	skip:

endm

; macro for decimal output
dec_output macro
	local start,repeat,display

	; input : bx
	; output : none

	
	; cmp bx, 0                      ; compare bx with 0
	; jge start                     ; jump to label start if bx>=0
	; mov ah, 2                      ; set output function
	; mov dl, "-"                    ; set dl='-'
	; int 21h                        ; print the character

	; neg bx                         ; take 2's complement of bx

	start:                        ; jump label

		mov ax, bx                     ; set ax=bx
		xor cx, cx                     ; clear cx
		mov bx, 10                     ; set bx=10

	repeat:                       ; loop label
		xor dx, dx                   ; clear dx
		div bx                       ; divide ax by bx
		push dx                      ; push dx onto the stack
		inc cx                       ; increment cx
		or ax, ax                    ; take or of ax with ax
		jne repeat                    ; jump to label repeat if zf=0

		mov ah, 2                      ; set output function

	display:                      ; loop label
		pop dx                       ; pop a value from stack to dx
		or dl, 30h                   ; convert decimal to ascii code
		int 21h                      ; print a character
		loop display

endm

; macro to take binary input
bin_input macro
	local skip,input
	; output: bx
	

	xor bx,bx

	mov ah,01h
	int 21h

	cmp al,0dh
	je skip

	input:
		xor ah,ah
		sub ax,'0'
		shl bx,1
		or bx,ax

		; take input
		mov ah,01h
		int 21h

		cmp al,0dh
		jne input

	skip:

endm

; macro to take binary output
bin_output macro
	local output,display_loop
	; input: bx
	
	mov ah,02h
	mov cx,0

	output:
		mov dx,bx
		and dx,01h
		add dx,'0'
		push dx
		inc cx
		shr bx,1

	jnz output

	mov cx,cx
	display_loop:
		pop dx
		int 21h
	loop display_loop

endm

pushall macro
	push ax
	push bx
	push cx
	push dx
endm

popall macro
	pop dx
	pop cx
	pop bx
	pop ax
endm
