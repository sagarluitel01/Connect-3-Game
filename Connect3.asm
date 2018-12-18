;SAGAR LUITEL
;CSCI 2525-001
;FINAL 
;CONNECT-THREE

TITLE Final.asm

include irvine32.inc

clearEAX TEXTEQU <mov eax, 0>
clearEBX TEXTEQU <mov ebx, 0>
clearECX TEXTEQU <mov ecx, 0>
clearEDX TEXTEQU <mov edx, 0>
clearESI TEXTEQU <mov esi, 0>
clearEDI TEXTEQU <mov edi, 0>

.data
win byte 0h
var1 byte 0h
player12 byte 0h

	string1 byte '!!YEA!! Blue WIN the game!!!', 0h
	string2 byte '!!YEA!! Yellow WIN the game!!!', 0h

table1 byte 4 dup(0h)			;table for checking if player/computer win
	   byte 4 dup(0h)
	   byte 4 dup(0h)
	   byte 4 dup(0h)
RowSize1 = 4		;row size is 4 

board1 byte '-------------', 0h
	   byte '|  |  |  |  |', 0h
	   byte '-------------', 0h
	   byte '|  |  |  |  |', 0h
	   byte '-------------', 0h
	   byte '|  |  |  |  |', 0h
	   byte '-------------', 0h
	   byte '|  |  |  |  |', 0h
	   byte '-------------', 0h

RowSize = 14  		;row size of board is 14
.code

main PROC
.data
prompt1 byte '-----WELCOME-To-Connect-Three------', 0ah, 0dh,
			 '---------------Rules---------------', 0ah, 0dh,
			 'The Goal is to connect three of your disk (horizontal, vertical, or diagonal)', 0ah, 0dh,
			 'By droping the disk into a slot at the top', 0ah, 0dh,
			 'You must choose which slot you want to drop your disk in', 0ah, 0dh,
			 'Each player will get Eight Chance to drop the disk', 0ah, 0dh,
			 'Whoever connects three disk first, will win the game', 0ah, 0dh, 0h

prompt2 byte '-----MAIN MENU------', 0ah, 0dh,
             '1. Player1 VS. Player2', 0Ah, 0Dh,
             '2. Player1 VS. Computer1', 0Ah, 0Dh, 
			 '3. Computer1 VS. Computer2', 0Ah, 0Dh,
             '4. Display Rules ', 0Ah, 0Dh,
             '5. Quit', 0Ah, 0Dh, 0h
			 
errorMsg byte 'Invalid Entry.  Please try again.', 0h
.code
	
clearEAX
clearEBX
clearECX
clearEDX
clearESI
clearEDI

mov edx, offset prompt1					;display the rules
call WriteString
call WaitMsg
fromHere:
	call clearT						;calling function which clears the table and board
	call Clrscr
	mov edx, 0
	mov edx, offset prompt2
	call WriteString				;display the menu
	call crlf
	call ReadDec					;user enter the option 

first:								;if 1 player1 vs player2
	cmp al, 1
	jne second
	call pVp
	call Crlf
	call WaitMsg
	jmp fromHere
	
second:								;if 2  player vs computer
	cmp al, 2
	jne third
	call pVc
	call Crlf
	call WaitMsg
	jmp fromHere
	
third:								;if 3 computer vs computer
	cmp al, 3	
	jne Fourth
	call cVc
	call Crlf
	call WaitMsg
	jmp fromHere

Fourth:
	cmp al, 4						;if 4 display the rule again
	jne Fifth
	call Clrscr
	mov edx, offset prompt1
	call WriteString
	call WaitMsg
	jmp fromHere

Sixth:
	mov edx, 0						;if user enter anything other than 1, 2, 3, 4, & 5 
	mov edx, offset errorMsg
	call WriteString				;display error message 
	jmp fromHere
	
Fifth:								;if 5 exit
	cmp al, 5
	jne Sixth
exit
main ENDP

;********************************************
;This is Player vs. Player function 
pVp PROC
.data
	promptA byte 'Player1 Please Enter the Colume Number (1, 2, 3, 4)', 0h  
	promptB byte 'Player2 Please Enter the Colume Number [1, 2, 3, 4]', 0h
.code
 mov ecx, 16					;there are 16 possible moves, 8 for each player 
L1:
	mov var1, 0					;holds the colume of table (board)---
	mov player12, 1				;player 1 is playing 				|
	mov edx, offset promptA		;									|
	call WriteString			;									|	
	call ReadDec 				;user enter the colume number 		|
	mov var1, al				;soter it in var1 <------------------
	call crlf
	call board					;call function which stores the disk in the board and display the board 
	call check					;call finction which check if player win or not 
	cmp win, 0					;variable win holds 0 or 1, so if its 1 this player won the game
	je L2
	jmp returnX
	
	
L2:
	mov var1, 0
	mov player12, 2				;player2 if playing now 
	mov edx, offset promptB 
	call WriteString
	call ReadDec				;read colume number from user
	mov var1, al
	call crlf
	call board
	call check
	cmp win, 1
	je returnX
	Loop L1

	returnX:
		mov win, 0
ret
pVp ENDP

;*********************************************
;this is player vs computer 
pVc PROC
.data
	promptC byte 'Player1 Please Enter the Colume Number (1, 2, 3, 4)', 0h  
.code
 mov ecx, 16
L3:
	mov var1, 0
	mov player12, 1
	mov edx, offset promptA
	call WriteString
	call ReadDec 
	mov var1, al
	call crlf
	call board
	call check
	cmp win, 0
	je L4
	jmp return2
	
	
L4:
	mov var1, 0
	mov player12, 2
	call Randomize			;seed the number
	mov eax, 3				;from 0 - 3
	call RandomRange		; call random range function
	add al, 1				; add 1 to it so it will be 1 - 4 
	mov var1, al			;soter it in var1 which holds the colume number 
	call crlf
	call board
	call check
	cmp win, 1
	je return2
	Loop L3

	return2:
	mov win, 0
ret
pVc ENDP

;******************************************
cVc PROC

 mov ecx, 16
L5:
	mov var1, 0
	mov player12, 1
	call Randomize
	mov eax, 4
	call RandomRange
	add al, 1
	mov var1, al
	call crlf
	call board
	call check
	cmp win, 0
	je L6
	jmp return3
	
L6:
	mov var1, 0
	mov player12, 2
	call Randomize
	mov eax, 4
	call RandomRange
	add al, 1
	mov var1, al
	call crlf
	call board
	call check
	cmp win, 1
	je return3
	Loop L5

	return3:
	mov win, 0
ret

ret
cVc ENDP

;*****************************************
;sotres the disk in board 
board PROC
.data
	RowFull byte 'This row is alredy full, you just lost your turn', 0h
.code

cmp var1, 1		;if colume is 1 jump to row 
jne col2	
mov esi, 1		
jmp row4

col2:			;if colume is 2 than 
cmp var1, 2
jne col3		;													 --------------
mov esi, 4		;move 4 in esi becasue colume 2 is colume 4 in board |1-|4-|7-|10-|
jmp row4		;													 --------------

col3:
cmp var1, 3
jne col4
mov esi, 7
jmp row4

col4:
mov esi, 10
jmp row4


row4:							;row 4
	mov ebx, offset table1	
	Row_Index = 3
	add ebx, RowSize1 * Row_Index
	push esi
	movzx esi, var1
	sub esi, 1
	mov al, [ebx+esi]
	pop esi
	cmp al, 0				;check if there is disk or it's empty
	jne row3				;if it's not empty jump to row3
	cmp player12, 1			;check if player1 is playing or player2 is playing 
	jne pl24
	mov edx, offset board1
	mov al, 219				;if player1 is playing store big squire 
	Row_Index = 7
	add edx, RowSize * Row_Index
	mov [edx+esi], al
	add edx, 1
	mov [edx+esi], al
	push esi
	movzx esi, var1
	sub esi, 1
	mov al, player12
	mov [ebx+esi], al	; & store 1 in table 
	pop esi 
	call disply1		; call display finction which put colors in the disk
	ret
	pl24:				;if player2 is playing 
	mov edx, offset board1
	mov al, 220			;store small rectangle in the board 
	Row_Index = 7
	add edx, RowSize * Row_Index
	mov [edx+esi], al
	add edx, 1
	mov [edx+esi], al
	push esi
	movzx esi, var1
	sub esi, 1
	mov al, player12
	mov [ebx+esi], al 		; store 2 in table
	pop esi
	call disply1	;diaply finction puts colors in the disk
	ret
row3:				;row 3
	mov ebx, offset table1
	Row_Index = 2
	add ebx, RowSize1 * Row_Index
	push esi
	movzx esi, var1
	sub esi, 1
	mov al, [ebx+esi]
	pop esi
	cmp al, 0				;if there is disk or it's empty
	jne row2				;if it's not empty jump to row2
	cmp player12, 1
	jne pl23
	mov edx, offset board1
	mov al, 219
	Row_Index = 5
	add edx, RowSize * Row_Index
	mov [edx+esi], al
	add edx, 1
	mov [edx+esi], al
	push esi
	movzx esi, var1
	sub esi, 1
	mov al, player12
	mov [ebx+esi], al 
	pop esi
	call disply1
	ret
	pl23:
	mov edx, offset board1
	mov al, 220
	Row_Index = 5
	add edx, RowSize * Row_Index
	mov [edx+esi], al
	add edx, 1
	mov [edx+esi], al
	push esi
	movzx esi, var1
	sub esi, 1
	mov al, player12
	mov [ebx+esi], al 
	pop esi
	call disply1
	ret
row2:
	mov ebx, offset table1
	Row_Index = 1
	add ebx, RowSize1 * Row_Index
	push esi
	movzx esi, var1
	sub esi, 1
	mov al, [ebx+esi]
	pop esi
	cmp al, 0				;if there is disk or it's empty
	jne row1				;if it's not empty jump to row1
	cmp player12, 1
	jne pl22
	mov edx, offset board1
	mov al, 219
	Row_Index = 3
	add edx, RowSize * Row_Index
	mov [edx+esi], al
	add edx, 1
	mov [edx+esi], al
	push esi
	movzx esi, var1
	sub esi, 1
	mov al, player12
	mov [ebx+esi], al 
	pop esi
	call disply1
	ret
	pl22:
	mov edx, offset board1
	mov al, 220
	Row_Index = 3
	add edx, RowSize * Row_Index
	mov [edx+esi], al
	add edx, 1
	mov [edx+esi], al
	push esi
	movzx esi, var1
	sub esi, 1
	mov al, player12
	mov [ebx+esi], al 
	pop esi
	call disply1
	ret

row1:
	mov ebx, offset table1
	Row_Index = 0
	add ebx, RowSize1 * Row_Index
	push esi
	movzx esi, var1
	sub esi, 1
	mov al, [ebx+esi]
	pop esi
	cmp al, 0			;if there is disk or it's empty
	jne ret1				;if it's not empty jump to retunr
	cmp player12, 1
	jne pl2
	mov edx, offset board1
	mov al, 219
	Row_Index = 1
	add edx, RowSize * Row_Index
	mov [edx+esi], al
	add edx, 1
	mov [edx+esi], al
	push esi
	movzx esi, var1
	sub esi, 1
	mov al, player12
	mov [ebx+esi], al 
	pop esi
	call disply1
	ret
	
	pl2:
	mov edx, offset board1
	mov al, 220
	Row_Index = 1
	add edx, RowSize * Row_Index
	mov [edx+esi], al
	add edx, 1
	mov [edx+esi], al
	push esi
	movzx esi, var1
	sub esi, 1
	mov al, player12
	mov [ebx+esi], al 
	pop esi
	call disply1
	ret

	ret1:
		call crlf
		mov edx, offset RowFull
		call WriteString
		call crlf
ret
board ENDP

;*************************************
disply1 PROC

	mov edx, 0
	mov esi, 0
	mov edx, offset board1
	push ecx
	mov ecx, 9
	loop1:
		cmp ecx, 0
		je exit1
		push ecx
		mov ecx, 14
		loop2:
			mov al, [edx+esi]
			cmp al, 219				;if squire
			je colr1				;jump to colr1
			cmp al, 220				;if rectangle
			je colr2				;jump to colr2
			push eax				;if not than white color in black background
			mov eax, 15
			call SetTextColor
			pop eax
			call WriteChar
			inc esi
			Loop loop2
		jmp jump1
		
			colr1: 				
			push eax
			mov eax, 1			;put blue color in the text
			call SetTextColor
			pop eax
			call WriteChar
			inc esi
			Loop loop2
			
		jmp jump1
		
			colr2: 
			push eax
			mov eax, 14			;put yellow in the text
			call SetTextColor
			pop eax
			call WriteChar
			inc esi
			Loop loop2
			
		jump1:
		pop ecx
		call crlf
		mov esi, 0
		add edx, 14
		add ebx, 4
		dec ecx
		jmp loop1
		;Loop loop1

	exit1:
	pop ecx
ret
disply1 ENDP

;*************************************
;check if three disk(colors) are connected
check PROC

push ecx

mov ebx, 0
mov ebx, offset table1
Row_Index = 0
Col_Index = 0
mov esi, Col_Index
add ebx, rowsize * Row_Index
mov ecx, 4								;loop 4 times
opt1:									; it will go through each row
	cmp win, 0
	jne retutnA
	call option1						;call function option1
	add ebx, rowsize * Row_Index		;incrementing row index
	Row_Index = Row_Index + 1
	Loop opt1		

	cmp win, 1
	je retutnA

mov ebx, 0
mov ebx, offset table1
Row_Index = 0
Col_Index = 0
mov esi, Col_Index
add ebx, rowsize * Row_Index
mov ecx, 4							;loop 4 times
opt2:								;it will go through each colume
	cmp win, 0
	jne retutnA
	call option2					;calling option2
	inc esi
	mov ebx, 0						
	mov ebx, offset table1			;set row index to 0
	Loop opt2
	
	cmp win, 0
	jne retutnA

mov ebx, 0
mov ebx, offset table1
Row_Index = 0
Col_Index = 0
mov esi, Col_Index
add ebx, rowsize * Row_Index
opt3:								;it will go through diagolan from row 1 row -  4
	call option3
	
	cmp win, 0
	jne retutnA
	
mov ebx, 0
mov ebx, offset table1
mov esi, 0
;Row_Index = 3
Col_Index = 0
mov esi, Col_Index
;add ebx, rowsize * Row_Index
add ebx, 12
opt4:								;it will go through diagolan from row 1 row -  4
	call option4
	cmp win, 0
	jne retutnA
	
retutnA:
	pop ecx
	ret	
	
check ENDP

;*****************************************
;*****************************************
option1 PROC
.data
	num1 byte 0h
	num2 byte 0h
.code
push ecx
mov ecx, 4
mov num1, 0
mov num2, 0
mov win, 0
opt0:
	cmp ecx, 0					;if ecx is 0 go to there
	je here1
	mov eax, 0
	mov al, [ebx+esi]			;move the current element of the table1 in al
	cmp al, 0					
	jne opt1						; if not equal jump to optE
	inc esi						; increment esi (colume index) 
	Loop opt0
	
	cmp num1, 3				;num1 holds the number of blue disk  compaire it with 3
	je optX1				; if equals jump to optX (to exit )
	cmp num2, 3				;num2 holds the number of yellow disk
	je optX2
	jmp return
	
opt1:
	mov eax, 0
	mov al, [ebx+esi]
	cmp al, 1				;compaire the current table element wiht 1 
	jne opt2				; if equals 
	inc num1				;increment num1
	inc esi
	Loop opt0
	
	cmp num1, 3		
	je optX1
	cmp num2, 3
	je optX2
	jmp return

opt2:
	mov eax, 0
	mov al, [ebx+esi]
	cmp al, 2				;compaire it wiht 2 
	jne opt2a				; if it is 2 than 
	inc num2				;increment num2
	inc esi					;increment colume index
	dec ecx					;decrement ecx (looping is too far so had to jump) 
	jmp opt0
	jmp here1
	
	opt2a:
		inc esi
		dec ecx
		jmp opt0
	
	here1:
	cmp num1, 3		
	je optX1
	cmp num2, 3
	je optX2
	jmp return
	
	optX1:
		;cmp num2, 1
		;je return
		mov edx, 0
		mov edx, offset string1
		call WriteString
		mov win, 1
		jmp return
		
	optX2:
		;cmp num1, 1
		;je return
		mov edx, 0
		mov edx, offset string2
		call WriteString
		mov win, 1
		jmp return
return:
	pop ecx
ret
option1 ENDP

;*************************************
;************************************
option2 PROC
.data
	num3 byte 0h
	num4 byte 0h
.code
push ecx
mov ecx, 4
mov num3, 0
mov num4, 0
mov win, 0
optA1:
	cmp ecx, 0
	je there1
	mov eax, 0
	mov al, [ebx+esi]
	cmp al, 0
	jne optE1
	add ebx, 4
	Loop optA1
	
	cmp num3, 3
	je optX3
	cmp num4, 3
	je optX4
	jmp return
	
optE1:
	mov eax, 0
	mov al, [ebx+esi]
	cmp al, 1
	jne optI1
	inc num3
	add ebx, 4
	Loop optA1
	
	cmp num3, 3
	je optX3
	cmp num4, 3
	je optX4
	jmp return

optI1:
	mov eax, 0
	mov al, [ebx+esi]
	cmp al, 2
	jne optUb
	inc num4
	add ebx, 4
	Loop optA1
	
	cmp num3, 3
	je optX3
	cmp num4, 3
	je optX4
	jmp return
	
	optUb:
		add ebx, 4
		dec ecx
		jmp optA1
	
	there1:
	cmp num3, 3
	je optX3
	cmp num4, 3
	je optX4
	jmp return
	
	optX3:
	cmp num4, 1
	je return
	mov edx, offset string1
	call WriteString
	mov win, 1
	jmp return
	
	optX4:
	cmp num3, 1
	je return
	mov edx, offset string2
	call WriteString
	mov win, 1
	jmp return
	
return:
	pop ecx
ret
option2 ENDP
;*************************************
;**************************************
option3 PROC
.data
num5 byte 0h
num6 byte 0h
.code

push ecx 
mov num5, 0
mov num6, 0
mov win, 0
mov ecx, 4
opt0a:
	cmp num5, 3
	je optXa
	cmp num6, 3
	je optXb
	mov eax, 0
	mov al, [ebx+esi]
	cmp al, 0
	jne opt1a
	inc esi
	add ebx, 4
	loop opt0a
	
	cmp num5, 3
	je optXa
	cmp num6, 3
	je optXb
	jmp return 
	
opt1a:
	mov eax, 0
	mov al, [ebx+esi]
	cmp al, 1
	jne opt2a
	inc esi
	inc num5
	add ebx, 4
	loop opt0a

	cmp num5, 3
	je optXa
	cmp num6, 3
	je optXb
	jmp return 
	
opt2a:
	inc esi
	inc num6
	add ebx, 4
	loop opt0a
	
	cmp num5, 3
	je optXa
	cmp num6, 3
	je optXb
	jmp return 
	
	optXa:
	cmp num6, 1
	je return
	mov edx, offset string1
	call WriteString
	mov win, 1
	jmp return					;added
	
	optXb:
	cmp num5, 1
	je return
	mov edx, offset string2
	call WriteString
	mov win, 1
	jmp return					;added (jmp return)
	
return:
	pop ecx
ret
option3 ENDP
;***************************************
;**************************************
option4 PROC
.data
num7 byte 0h
num8 byte 0h
.code

push ecx 
mov num7, 0
mov num8, 0
mov win, 0
mov ecx, 4
opt0a:
	cmp num7, 3
	je optXa
	cmp num8, 3
	je optXb
	mov eax, 0
	mov al, [ebx+esi]
	cmp al, 0
	jne opt1a
	inc esi
	sub ebx, 4
	loop opt0a
	
	cmp num7, 3
	je optXa
	cmp num8, 3
	je optXb
	jmp return 
	
opt1a:
	mov eax, 0
	mov al, [ebx+esi]
	cmp al, 1
	jne opt2a
	inc esi
	inc num7
	sub ebx, 4
	loop opt0a

	cmp num7, 3
	je optXa
	cmp num8, 3
	je optXb
	jmp return 
	
opt2a:
	inc esi
	inc num8
	sub ebx, 4
	loop opt0a
	
	cmp num7, 3
	je optXa
	cmp num8, 3
	je optXb
	jmp return 
	
	optXa:
	cmp num8, 1
	je return
	mov edx, offset string1
	call WriteString
	mov win, 1
	jmp return
	
	optXb:
	cmp num7, 1
	je return
	mov edx, offset string2
	call WriteString
	mov win, 1
	jmp return
	
return:
	pop ecx
ret
option4 ENDP
;************************************************
;**********************************************
;this function clears the table and board to play new game 
clearT PROC

mov ebx, offset board1
mov ecx, 4
mov esi, 1
add ebx, RowSize * 1		;colume 1 
clr1:	
	mov al, 20h
	mov [ebx+esi], al		;just inserting space which will remove the disk 
	inc esi
	mov [ebx+esi], al
	inc esi
	inc esi
	Loop clr1

mov ebx, offset board1
mov ecx, 4
mov esi, 1
add ebx, RowSize * 3
clr2:
	mov al, 20h
	mov [ebx+esi], al
	inc esi
	mov [ebx+esi], al
	inc esi
	inc esi
	Loop clr2	

mov ebx, offset board1
mov ecx, 4
mov esi, 1
add ebx, RowSize * 5
clr3:
	mov al, 20h
	mov [ebx+esi], al
	inc esi
	mov [ebx+esi], al
	inc esi
	inc esi
	Loop clr3	
	
mov ebx, offset board1
mov ecx, 4
mov esi, 1
add ebx, RowSize * 7
clr4:
	mov al, 20h
	mov [ebx+esi], al
	inc esi
	mov [ebx+esi], al
	inc esi
	inc esi
	Loop clr4	
	
mov ebx, offset table1		;clearing the table as well
mov ecx, 16
clar5:
	mov al, 0				; moving 0 in all the position 
	mov [ebx], al
	inc ebx
	loop clar5

ret
clearT ENDP
end main