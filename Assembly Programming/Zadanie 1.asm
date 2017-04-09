;Zadanie Ë. [1.], 19. uloha
;Miroslav Kuchar
;Text zadania: NapÌöte program (v JSI), ktor˝ umoûnÌ pouûÌvateæovi pomocou menu opakovane vykonaù nasleduj˙ce akcie: zadaù meno s˙boru, vypÌsaù obsah s˙boru, vypÌsaù 
;dÂûku s˙boru (v desiatkovej s˙stave, v bajtoch), vykonaù pridelen˙ ˙lohu, ukonËiù program. Pri kaûdom zobrazenÌ menu sa vypÌöe aj aktu·lny d·tum a Ëas. Program naËÌta voæbu 
;pouûÌvateæa z kl·vesnice. V programe vhodne pouûite makro s parametrom, ako aj vhodnÈ volania OS (resp. BIOS) pre naËÌtanie znaku, nastavenie kurzora, v˝pis reùazca, zmazanie 
;obrazovky a pod. Na spracovanie poæa znakov musia byù vhodne pouûitÈ reùazcovÈ inötrukcie. Pridelen· ˙loha musÌ byù realizovan· ako extern· proced˙ra (kompilovan· samostatne a 
;prilinkovan· k v˝slednÈmu programu). DefinÌcie makier musia byù v samostatnom s˙bore. Program musÌ korektne spracovaù s˙bory s dÂûkou aspoÚ do 128 kB. Pri ËÌtanÌ vyuûite pole vhodnej
;veækosti (buffer), priËom zo s˙boru do pam‰te sa bude pres˙vaù vûdy (aû na poslednÈ ËÌtanie) cel· veækosù poæa. Oöetrite chybovÈ stavy.
;31.3.2015
;1. rocnik, 2014/2015, 2. semester, PKSS 




title zadanie1
zas 	segment stack
		db  	512 dup(?) 
zas 	ends



data segment				;v datovom segmente si inicializujem premenne ktore budem pouzivat v mojom programe

N 			DB 10,13,'Push the N button to write the name of the file$'
V 			DB 10,13,'Push the V button to write the file$'
Ce 			DB 10,13,'Push the C button to the length of the file$'
Pr			DB 10,13,'Push the L button to write the number of rows which contains numbers$'
Ko  			DB 10,13,'Push the K button to end program$'
QUEST 		DB 'Enter the name of the file:$',10,13
NL  			DB 10,13,'$'
PEK 			DB 10,13,'=======================$'
VD		DB 'The length of the file in bytes is: $',10,13
VP		DB 'Number of rows where are numbers is: $',10,13
ERR0 		DB 10,13,'File wasnt found$'
ERR1 		DB 10,13,'Theres no file in that location$'
ERR2 		DB 10,13,'Firstly push the N button$'
NAZOV		DB 64 dup(?)
POCET       DW   0
POCET10     DW   0
TISICKY     DW   0
POCETT      DW   0
JEDNOTKA    DW   1
POCET2      DW   0
POCET3	    DW   0
POCETC      DW   0
POCETC2     DW   0
POCETC6     DW   0
H           DW   0
M	    	DW   0
I			DB	 0
POCETCIF    DW   0
BUFFER1     DB   1001 DUP(?)
BUFFER2     DB   1001 DUP(?)
NACITANE	DW   0



ends

extrn time:proc				;pridavam externnu proceduru na datum a cas
code segment public
assume cs:code, ds:data, ss:zas

vypis   MACRO TEXT 	                ;makro pre funkciu vypis
		mov DX, OFFSET TEXT           
		MOV AH,09H
		INT 21H
        ENDM
MAIN:
MOV AX, 0003                ; mazanie obrazovky
INT 10H                     ; prerusenie 
start:			    ; vypis formatu vypisania
mov bx,seg data
mov ds,bx

vypis NL
vypis PEK
vypis NL

call time
vypis PEK
vypis NL
vypis N
vypis NL
vypis V
vypis NL
vypis Ce
vypis NL
vypis Pr
vypis NL
vypis Ko
vypis NL
vypis NL

menu:
xor	ax,ax		;nulovanie ax 
	mov	ah,7	;nacitanie volby menu
	int	21h		

	cmp	al,'n'
	jne	vyp
	call otvor	;ak bolo stlacene 'n' tak sa vykona procedura na otvorenie suboru
	
	jmp	start
;90	
vyp:	cmp	al,'v'
	jne	spoc
	call vypisanie	;ak bolo stlacene 'v' tak sa vykona procedura vypisu subora na obrazovku
	
	jmp	start

spoc:	cmp	al,'c'
	jne	proce
	call spocitanie	;ak bolo stlacene 'c' tak sa vykona procedura ktora nam spocita byty v subore
	
	jmp	start

proce:  cmp	al, 'l'
	jne	konc
	call 	procedura

	jmp     start
	
konc:	cmp	al,'k'	;ak bolo stlacene 'k' tak sa program ukonci
	jne	menu
	jmp	koniec

;------------------------------------------------------------------------------------------------------------------------------------------------------------------	
;menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu menu 
;------------------------------------------------------------------------------------------------------------------------------------------------------------------

procedura	proc

			MOV AX, SEG DATA            ; do AX vloz adresu segmentu DATA
			MOV DS, AX                  ; segmentovu adresu presun do DS
		        MOV ES, AX                  ; adresa segmentu sa ulozi aj do es kvoli retazcovym instrukciam
				MOV AX, 0003                ; funkcia na mazanie obrazovky
	            INT 10H 					; prerusenie
			xor cx,cx
nulovanie1:
				mov BX,CX
				mov [BUFFER2+BX], 0
				inc cx
				cmp cx, 1001
				jne nulovanie1
				
				MOV BUFFER2,0  
				MOV POCETC,0  
				MOV POCETC2,0 
				MOV POCETC6,0
				MOV TISICKY, 0
				
		        
			MOV AH,3DH                      ; otvorenie suboru
             MOV AL,0                       ; citanie 
             MOV DX,OFFSET NAZOV            ; nazov suboru na otvorenie
             INT 21H                        ; prerusenie
			 JC C
			JMP D
C:			JMP SUBORUNIET                    ; ak subor nebol najdeny
D:
            
			
			
			MOV DX, OFFSET BUFFER2
			MOV CX,1000
             MOV BX,AX                      ; do bx sa ulozi handler aktualneho suboru
			 MOV M,BX                       ; bx sa ulozi do M 
			 JMP CIT
NAV2:			CMP NACITANE, 1000
			JNZ RETAZECP
CIT:     
             MOV DX, OFFSET BUFFER2 
			 MOV AH,3FH                     ; citanie suboru
             INT 21H                        ; prerusenie   
			 xor dx, dx
			 MOV NACITANE, AX
             
			 
			  MOV SI, OFFSET BUFFER2
NAV:		
			 CMP DX, NACITANE
					JZ NAV2
			 LODSB
			 
			 add Dx,1
			
             CMP AL,'9'
			 JG NAV 
				
			CMP AL,'0'		
			JL NAV
			JMP PRIDAJ
			
KR:			
					CMP DX, NACITANE
					
					JZ NAV2
					LODSB
					ADD DX,1
					CMP AL,10
					JZ NAV
             		                     
					
			JMP KR
			
			
PRIDAJ:		MOV AX, JEDNOTKA	
			ADD POCETC,AX
			CMP POCETC, 1000
			JZ PRIDAJTIS
				JMP KR

PRIDAJTIS:	MOV AX, JEDNOTKA
			ADD TISICKY, AX
			MOV POCETC, 0
			JMP KR



				
			 
 
RETAZECP:			
				
				MOV AX,TISICKY
				
KONCI:				;vypis VP
				CMP TISICKY, 0
				JZ CYKLUSP1
			
			
DELENIETISICOK:  xor cx,cx
			     CMP AX,0                    ; ak v ax este nie je nula pokracuje sa v deleni 
			     JZ  VYPISPOCTUP                 ; inak sa skoci na navestie vypispoctu
				 MOV DX, 0                   ; do dx sa ulozi nula 
			     MOV CL,10                   ; do cl sa ulozi 10, pretoze sa bude delit desiatimi
			     DIV CX                      ; uskutocni sa delenie, kedy sa hodnota v ax deli cl a vysledok sa ulozi do ax a zvysok do dx  
			     ADD DL,30H                  ; premena znaku na cislicu
			     PUSH DX                     ; vlozenie na vrchol zasobnika
			     INC POCETC6                  ; inkrementacia poctu2, co je pomocna premenna pre ulozenie poctu cislic
			     JMP DELENIETISICOK                  ; skok na navestie cyklus			
			
CYKLUSP1:		MOV AX,POCETC 
				MOV POCETC6, 0
		
CYKLUSP:         xor cx,cx
				 CMP AX,0                    ; ak v ax este nie je nula pokracuje sa v deleni 
			     JZ VYPISPOCTU3P               ; inak sa skoci na navestie vypispoctu
				 MOV DX, 0                   ; do dx sa ulozi nula 
			     MOV CL,10                   ; do cl sa ulozi 10, pretoze sa bude delit desiatimi
			     DIV CX                      ; uskutocni sa delenie, kedy sa hodnota v ax deli cl a vysledok sa ulozi do ax a zvysok do dx  
			     ADD DL,30H                  ; premena znaku na cislicu
			     PUSH DX                     ; vlozenie na vrchol zasobnika
			     INC POCETC2                  ; inkrementacia poctu2, co je pomocna premenna pre ulozenie poctu cislic
			     JMP CYKLUSP                  ; skok na navestie cyklus

VYPISPOCTU3P:	 
			     MOV CX,POCETC2               ; do CX sa ulozi pocet cislic, aby sa mohol vykonavat cyklus 
			     ;CMP CX, 0
			     ADD CX, POCETC6
			     JMP VYPISPOCTU2P				 

VYPISPOCTUP:	 
			     MOV CX,POCETC6               ; do cx sa ulozi pocet cislic, aby sa mohol vykonavat cyklus 
				 CMP CX, 0
			     JZ CYKLUSP1
VYPISPOCTU2P:			 
			     POP DX                      ; vyber z vrcholu zasobnika
			     MOV AH,02H                  ; funkcia na vypis znaku, v tomto pripade sa vypisuje nasa cislica
			     INT 21H                     ; prerusenie
			     LOOP VYPISPOCTU2P            ; dekrementacia cx a ak este nie je nula skoci sa na navestie vypispoctu2P
				 
				MOV CX, POCETC6
			     CMP CX, 0
			     JNZ CYKLUSP1
                             vypis NL	                 ; novy riadok 
	
				 MOV AH,3EH                  ; funkcia na zatvorenie suboru
				 MOV BX, M                   ; vlozenie handlera do registra bx 
				 INT 21H                     ; prerusenie 
				jmp skocp
SUBORUNIET:  vypis ERR0					 ; vypis chybovych hlasok
			 vypis ERR1					 
				 
skocp:				 
ret
				endp







;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno
;------------------------------------------------------------------------------------------------------------------------------------------------------------------

otvor	proc
			MOV AX, SEG DATA            ; do AX vloz adresu segmentu DATA
		        MOV DS, AX                  ; segmentovu adresu presun do DS registra
		        MOV ES, AX                  ; adresa segmentu sa ulozi aj do ES kvoli instrukciam na retazce
			MOV AX, 0003                ; funkcia na mazanie obrazovky
	             INT 10H                        ; prerusenie 
		        vypis QUEST                 ; vypis otazky pre zadanie nazvu suboru
			vypis NL		    ; novy riadok
	             CLD                         ; vynulovanie direction flagu, vsetky retazcove instrukcie budu inkrementovat registre SI a DI
	             LEA DI,NAZOV                ; prenesiem efektivnu adresu do registra 
AGAIN:           MOV AH,01H                  ; nacitanie znaku s echom
                 INT 21H                     ; prerusenie
                 CMP AL,13                   ; bol stlaceny enter?
		 JZ NEXT                    ; ak ano nazov bol zadany a skoci SI na navestie NEXT  
POKRACOVANIE:
                 STOSB                       ; ak nebol stlaceny enter zadany znak sa ulozi do retazca nazov a SI sa inkrementuje
			     JMP AGAIN                   ; skok na navestie AGAIN
NEXT:           MOV AL,'$'                  ; ukoncovaci znak sa ulozi do AL 
                 STOSB                       ; ukoncenie retazca a inkrementacia SI 
				 MOV AH,3DH                     ; funkcia na otvorenie suboru
				 MOV AL,0                       ; na citanie 
				 MOV DX,OFFSET NAZOV            ; nazov suboru, ktory ma byt otvoreny
				 INT 21H                        ; prerusenie
				 JC NOTFOUND                    ; ak subor nebol najdeny vypise chybu
				 XOR AX, AX
				 jmp skac1			; ak bol procedura skonci
NOTFOUND:   	 vypis ERR0
skac1:				 ret
				 endp				; ukoncim proceduru

;------------------------------------------------------------------------------------------------------------------------------------------------------------------			
;meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno meno
;------------------------------------------------------------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis 
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
			
vypisanie proc
			MOV AX, SEG DATA            ; do AX vloz adresu segmentu DATA
		        MOV DS, AX                  ; segmentovu adresu presunie do DS
		        MOV ES, AX                  ; adresa segmentu sa ulozi aj do ES kvoli retazcovym instrukciam
			MOV AX, 0003                ; mazanie obrazovky
	            INT 10H 
			MOV AH,3DH                      ; funkcia na otvorenie suboru
             MOV AL,0                        ; na citanie 
             MOV DX,OFFSET NAZOV             ; nazov suboru, ktory ma byt otvoreny
             INT 21H                         ; prerusenie
			 JC NOTFOUND1        ; ak subor nebol najdeny
             MOV DX,OFFSET BUFFER1           ; bude sa nacitavat do BUFFER1 retazec
             MOV CX,50                       ; po 50 znakoch 
             MOV BX,AX                       ; do bx sa ulozi handler aktualneho suboru
			 MOV H,BX            ; bx sa ulozi do h 
READ:     
             MOV AH,3FH                      ; funkcia na citanie suboru
             INT 21H                         ; prerusenie   
             CMP AX,50                       ; kontrolujem ci bolo nacitanych 50 znakov, alebo bol uz koniec suboru
             JNZ PRINT                       ; bol koniec suboru, skoci sa na navestie print
			 ;ADD POCET,50                    ; bolo nacitanych 50 znakov teda pocet sa zvacsi o 50 
			 MOV SI,OFFSET BUFFER1           ; do SI sa ulozi offset retazca BUFFER1 
			 ADD SI,AX                       ; SI sa zvacsi o pocet nacitanych znakov
			 MOV BYTE PTR[SI],'$'            ; ukoncenie retazca
             vypis BUFFER1			; vypis retazca
			 MOV DX,OFFSET BUFFER1           ; do DX sa znova ulozi offset retazca do ktoreho sa bude nacitavat  
             JMP READ			         ; skok na navestie READ	
PRINT:         
             ;ADD POCET,AX                    ; bol koniec suboru,nebolo nacitanych uz 50 znakov a pocet sa zvacsi o pocet nacitanych znakov  
             MOV BX,AX                       ; do BX sa ulozi pocet nacitanych znakov
             MOV BYTE PTR[BUFFER1+BX],'$'    ; ukoncenie retazca
			 vypis BUFFER1	                 ; vypis retazca BUFFER1	  
			 
			MOV AX,POCET                 ;do AX sa ulozi pocet znakov	
			 jmp skac2
NOTFOUND1:  vypis ERR1
			 vypis ERR2
skac2:		 ret
				endp		; ukoncim proceduru
;280
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis vypis 
;------------------------------------------------------------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;290				
spocitanie proc	 
				MOV AX, SEG DATA            ; do AX vloz adresu segmentu DATA
		        MOV DS, AX                  ; segmentovu adresu presun do DS
		        MOV ES, AX                  ; adresa segmentu sa ulozi aj do es kvoli retazcovym instrukciam
				MOV AX, 0003                ; mazanie obrazovky
	            INT 10H 

			xor cx,cx
nulovanie:
		mov BX,CX
		mov [BUFFER1+BX], 0
		inc cx
		cmp cx, 1001
		jne nulovanie
		
		
		MOV BUFFER1,0 
		MOV POCET,0 
		mov pocett,0		
		MOV POCET2,0 


			 MOV AH,3DH                      ; funkcia na otvorenie suboru
             MOV AL,0                        ; na citanie 
             MOV DX,OFFSET NAZOV             ; nazov suboru, ktory ma byt otvoreny
             INT 21H                         ; prerusenie
			 JC A
			JMP B
A:			JMP NOTFOUND2                    ; ak subor nebol najdeny
B:
             MOV DX,OFFSET BUFFER1           ; bude sa nacitavat do BUFFER1 retazec
             MOV CX,1000                       ; po 1000 znakoch 
             MOV BX,AX                       ; do bx sa ulozi handler aktualneho suboru
			 MOV H,BX                        ; bx sa ulozi do h 
READ2:     
             MOV AH,3FH                      ; funkcia na citanie suboru
             INT 21H                         ; prerusenie   
             CMP AX,1000                       ; kontrola ci bolo nacitanych 1000 znakov, alebo bol uz koniec suboru
             JNZ DALSI
			 MOV AX, JEDNOTKA                       ; bol koniec suboru, skoci sa na navestie DALSI
			 ADD POCETT,AX                    ; bolo nacitanych 50 znakov teda pocet sa zvacsi o 50 
			;vypis POCETT
			;vypis NL
			
             JMP READ2			         ; skok na navestie READ	

DALSI:		
			 ADD POCET,AX                    ; bol koniec suboru,nebolo nacitanych uz 1000 znakov a pocet sa zvacsi o pocet nacitanych znakov  
             MOV BX,AX                       ; do bx sa ulozi pocet nacitanych znakov
             MOV BYTE PTR[BUFFER1+BX],'$'    ; ukoncenie retazca
			vypis VD	     ; vypise do konzoly premennu VD ktora nam hovori o tom kolko bytov ma subor
			MOV AX,POCETT 

CYKLUST:          	     CMP AX,0                    ; ak v ax este nie je nula pokracuje sa v deleni 
			     JZ VYPISPOCTU               ; inak sa skoci na navestie vypispoctu
				 MOV DX, 0                   ; do dx sa ulozi nula 
				 xor cx,cx
			     MOV CL,10                   ; do cl sa ulozi 10, pretoze sa bude delit desiatimi
			     DIV CX                      ; uskutocni sa delenie, kedy sa hodnota v AX deli CL a vysledok sa ulozi do AX a zvysok do DX  
			     ADD DL,30H                  ; premena znaku na cislicu podla ASCII tabulky lebo 0 ma hodnotu 30H, 1 ma hodnotu 31H atd
			     PUSH DX                     ; vlozenie na vrchol zasobnika
			     INC POCET10                  ; inkrementacia poctu2, co je pomocna premenna pre ulozenie poctu cislic
			     JMP CYKLUST                  ; skok na navestie cyklus

;MOV pocet2, 0


CYKLUS:          	    MOV AX, POCET
			    MOV POCET10, 0
CYKLUS3:
				 CMP AX,0                    ; ak v ax este nie je nula pokracuje sa v deleni 
			     JZ VYPISPOCTU3               ; inak sa skoci na navestie vypispoctu
				 MOV DX, 0               ; do dx sa ulozi nula 
			     MOV CL,10                   ; do cl sa ulozi 10, pretoze sa bude delit desiatimi
			     DIV CX                      ; uskutocni sa delenie, kedy sa hodnota v AX deli CL a vysledok sa ulozi do AX a zvysok do DX  
			     ADD DL,30H                  ; premena znaku na cislicu podla ASCII tabulky lebo 0 ma hodnotu 30H, 1 ma hodnotu 31H atd
			     PUSH DX                     ; MOZNO TU!!! LEBO DX UZ SU NEJAKE CIFRY
			     INC POCET2                  ; inkrementacia poctu2, co je pomocna premenna pre ulozenie poctu cislic
			     JMP CYKLUS3                 ; skok na navestie cyklus
VYPISPOCTU3:	 
			     MOV CX,POCET2               ; do CX sa ulozi pocet cislic, aby sa mohol vykonavat cyklus 
			     ;CMP CX, 0
			     ADD CX, POCET10
			     JMP VYPISPOCTU2

VYPISPOCTU:	 
			     MOV CX,POCET10              ; do CX sa ulozi pocet cislic, aby sa mohol vykonavat cyklus 
			     CMP CX, 0
			     JZ CYKLUS

VYPISPOCTU2:			 
			     POP DX                      ; vyber z vrcholu zasobnika
			     MOV AH,02H                  ; funkcia na vypis znaku, v tomto pripade sa vypisuje nasa cislica
			     INT 21H                     ; prerusenie
			     LOOP VYPISPOCTU2            ; dekrementacia CX a ak este nie je nula skoci sa na navestie vypispoctu2
			     
				 
			     MOV CX, POCET10
			     CMP CX, 0
			     JNZ CYKLUS
                             vypis NL	                 ; novy riadok 
	;vyhodil som uzavretie suboru		         ; funkcia na zatvorenie suboru
				 MOV BX, H               ; vlozenie handlera do registra bx 
				 INT 21H                 ; prerusenie 
				 jmp skac3
NOTFOUND2:  	vypis ERR1
				vypis ERR2
skac3:			ret
				endp			 ;ukoncim proceduru

;------------------------------------------------------------------------------------------------------------------------------------------------------------------	
;spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie spocitanie
;------------------------------------------------------------------------------------------------------------------------------------------------------------------

koniec:					; ukoncenie programu
	
	MOV AH,3EH
	mov ah,4ch
	int 21h
	ends				; ukoncim segment
	end MAIN			; ukoncim main

;------------------------------------------------------------------------------------------------------------------------------------------------------------------
;koniec koniec koniec koniec koniec koniec koniec koniec koniec koniec koniec koniec koniec koniec koniec koniec koniec koniec koniec koniec koniec koniec koniec 
;------------------------------------------------------------------------------------------------------------------------------------------------------------------



;======================================================================================================================================================================
;======================================================================================================================================================================
;Zhodnotenie:
;Program je funkcny, funguje nacitanie mena suboru, vypis suboru, funguje datum a cas na stotiny sekund, a funguje vypis velkosti suboru.Ukoncit program je mozne tiez.
;Vypis dlzky suboru trosku chapruje ked klikame nan viackrat, ale na prvy krat nam vypisuje korektne. Problem je v tom ze treba by bolo vyprazdnit registre do ktorych
;sa nacitaly znaky. Program bol vypracovany v NotePade a kompilovany v DosBoxe s kompilatorom Tasm 1.4 pre Windows 7/8 64bitovy.
;ako som uz hovoril pred tym, program sa chova spravne az na tu proceduru z ktorou vypisujeme dlzku, to funguje len na prvy krat potom sa to zdvoj-, ztroj- atd nasobuje.
;so sluzbami DOS som nemal problemy az na otorenie noveho textoveho dokumentu cez konzolu, to ma nechcel pocuvat a musel som rucne vytvorit textak.
;vylepsenia mozno ze su nejake ktore by napomohly rychlosti programu, ale kedze som mal problem na zaciatku s pochopenim tohto jazyka, tak som neskutocne stastny
;ze som to tak-ako napisal ako je vyssie uvedene, tesim sa ze mi to funguje :)
;vyuzival som mnoho premennych, s nazvami ktore boly pre mna lahko zapametatelne, viacero cyklov, zdrojovy kod som si porozdeloval vyzualne na bloky aby sa v tom kode 
;dalo lepsie citat. Kazdy krok som si uz od zaciatku komentoval aby sa mi pripomenulo na druhy den co som vlastne tym chcel napisat,
;to mi moc pomohlo pri vytvarani projektu.

;======================================================================================================================================================================
;======================================================================================================================================================================