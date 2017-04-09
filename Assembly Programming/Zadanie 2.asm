title zadanie2
zas 	segment stack
		db  	512 dup(?) 
zas 	ends

data segment
prvecislo 		DB 10,13, 'Zadaj prve cislo z intervalu 0 a 99$'
druhecislo		DB 10,13, 'Zadaj druhe cislo z intervalu 0 a 99$'
par				DB 10,13, 'Sucet je parny$'
suc    			DB 10,13, 'Sucet radu je:$'
chyba1			DB 10,13, 'Zadal si mimo intervalu$'
NL  			DB 10,13,'$'
MAX				DB 3
DLZKA			DB ?
BUFF			DB  4 dup('$')
NUMBA			DW	0
NUMBA1			DW	0
NUMBA2			DW	0
POCETC2			DW  0
DESAT			DB  10



ends

code segment public

assume cs:code, ds:data, ss:zas

vypis   MACRO TEXT 	                ;makro pre funkciu vypis
		mov DX, OFFSET TEXT           
		MOV AH,09H
		INT 21H
        ENDM
		
MAIN:
		mov bx,seg data
		mov ds,bx
ZNOVA:	xor cx, cx
		nulovanie1:
				mov BX,CX
				mov [BUFF+BX], 0
				inc cx
				cmp cx, 4
				jne nulovanie1
		MOV NUMBA,0
		MOV NUMBA1,0
		MOV NUMBA2,0
		MOV DLZKA, 0
		MOV POCETC2,0
		
		
		vypis NL
		vypis prvecislo
		vypis NL
		mov ah, 10
		mov DX, OFFSET MAX
		int 21H
		
		
		XOR BH, BH
		MOV BL, DLZKA
		MOV BUFF[BX], '$'
		
		call konvert
	
		MOV AX, NUMBA[0]
		MOV NUMBA1, AX
		
		vypis druhecislo
		vypis NL
		mov ah, 10
		mov DX, OFFSET MAX
		int 21H
		
		
		XOR BH, BH
		MOV BL, DLZKA
		MOV BUFF[BX], '$'
		
		call konvert
		
		MOV AX, NUMBA[0]
		MOV NUMBA2, AX

		
		
		mov AX, NUMBA1
		
		CMP AX, NUMBA2
		JL VYMENA
		push NUMBA1
		push NUMBA2
spat:
		call spocitanie
		call vypisanie
		jmp UKONCENIE
		
VYMENA:
		MOV BX, NUMBA2[0]
		MOV NUMBA2, AX
		MOV NUMBA1, BX
		push NUMBA1
		push NUMBA2
		JMP spat
;==============================================================================
konvert			proc
	
	xor AX, AX
	MOV NUMBA, AX
	xor BL, BL
	MOV CL, 1
	MOV SI, OFFSET BUFF
	MOV AL, DLZKA[0]
	ADD SI, AX
	DEC SI
	STD
	Mov DL, DLZKA[0]
skok:	XOR AX, AX
		LODSB
		
		SUB AL, 30H
		MUL CL
		ADD NUMBA, AX
		XOR AX, AX
		MOV AL, CL
		MUL DESAT
		MOV CX, AX
		ADD BL, 1
		CMP BL, DL
		JNZ skok
ret 
	endp
;================================================================================
spocitanie		proc
	push BP
	MOV BP, SP
	MOV CX, [BP+6]			;cx je vacsi NUMBA1
	MOV BX, [BP+4]			;NUMBA2
	
	ADD CX,BX
	MOV AX, [BP+6]
	SUB AX, BX
	INC AX
	MUL CX
	MOV CL, 2
	DIV CX
	;VYSLEDOK V AX
	MOV NUMBA, AX
	xor AX, AX
		
		
		
		
		MOV AX, NUMBA
		AND AX, 1
		cmp AX, 0
		JZ SKOKY			
		JMP BEZ
		
SKOKY:		vypis par
		mov [bp+2], 009Eh
		

BEZ:	MOV SP,BP	
		POP BP
ret 
	endp

OK: JMP ZNOVA
;================================================================================
		
vypisanie		proc
				vypis suc
				MOV AX, NUMBA
				xor BX, BX
				
	delenie:		CMP AX, 0
					
					JZ konciD
					xor cx, cx
					MOV DX, 0                   ; do dx sa ulozi nula 
					MOV CL,10                   ; do cl sa ulozi 10, pretoze sa bude delit desiatimi
					DIV CX                      ; uskutocni sa delenie, kedy sa hodnota v ax deli cl a vysledok sa ulozi do ax a zvysok do dx  
					ADD DL,30H                  ; premena znaku na cislicu
					PUSH DX                     ; vlozenie na vrchol zasobnika
					INC POCETC2                  ; inkrementacia poctu2, co je pomocna premenna pre ulozenie poctu cislic
					JMP delenie 
					
	konciD:			MOV CX, POCETC2
					
	VYPISCISLA:		POP DX                      ; vyber z vrcholu zasobnika
					MOV AH,02H                  ; funkcia na vypis znaku, v tomto pripade sa vypisuje nasa cislica
					INT 21H                     ; prerusenie
					LOOP VYPISCISLA            ; dekrementacia cx a ak este nie je nula skoci sa na navestie vypispoctu2P
ret
	endp
	
	
UKONCENIE:
		XOR AX,AX
	MOV AX, NUMBA2
	CMP NUMBA1, AX
	JNE OK
		mov ah,4ch
		int 21h
		ends
		end MAIN