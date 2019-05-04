ORG 0
	LDA #01h
	PUSH
	LDA #00h
	PUSH
	JSR PRINT
	HLT
END 0


ORG 20h
PRINT:			;entrada: endereco do numero a ser exibido
	POP			;salva endereco de retorno
	STA STP
	POP
	STA STP+1

	POP			;salva endereco da variavel
	STA ADR
	POP
	STA ADR+1

LOOP1:			;while (i < 16)
	LDA #10h
	SUB I
	JZ END1

	LDA @ADR	;converte digito para ascii
	AND #01h
	ADD #30h
	STA @PTR

	LDA @ADR	;desloca variavel
	SHR
	STA @ADR

	LDA PTR		;incrementa ponteiro
	ADD #1
	STA PTR
	LDA PTR+1
	ADC #0
	STA PTR+1

	LDA I		;confere se a parte baixa acabou
	SUB #07h
	JNZ KEEP

	LDA ADR		;muda para parte alta
	ADD #1
	STA ADR
	LDA ADR+1
	ADC #0
	STA ADR+1

KEEP:			;incrementa contador
	LDA I
	ADD #1
	STA I
	JMP LOOP1

END1:
	OUT 3		;limpa banner

LOOP2:			;while (i > 0)
	LDA I
	JZ END2
	SUB #1
	STA I

	LDA PTR		;decrementa ponteiro
	SUB #1
	STA PTR

	LDA @PTR	;imprime caractere
	OUT 2
	JMP LOOP2

END2:
	LDA STP+1	;recoloca endereco de retorno e retorna
	PUSH
	LDA STP
	PUSH
	RET

STP:			;endereco de retorno
	DW 0
ADR:			;endereco da variavel
	DW 0
STR:			;vetor contendo caracteres ascii
	DS 16
PTR:			;ponteiro do vetor
	DW STR
I:				;variavel do loop
	DB 0


ORG 100h
	DW 0F00Fh
