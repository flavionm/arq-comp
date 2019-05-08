ORG 0
	LDA #03h
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
	STA ADRL
	ADD #1
	STA ADRH
	POP
	STA ADRL+1
	ADC #0
	STA ADRH+1

	LDA @ADRH	;checa se negativo
	AND #80h
	SUB #80h
	JNZ ENDIF1

	LDA ADRL+1	;chama conversao para positivo
	PUSH
	LDA ADRL
	PUSH
	JSR TWOS
	POP
	POP

	LDA #2Dh		;muda sinal para negativo
	STA SIGN

ENDIF1:
	LDA I
LOOP1:			;while (i < 16)
	SUB #10h
	JZ END1

	LDA #0		;carrega contador
	STA J
LOOP2:			;while (j < 5)
	SUB #5
	JZ END2

	LDA @PTR	;if (digit > 5)
	SUB #5
	JN ENDIF2

	LDA @PTR	;soma 3
	ADD #3
	STA @PTR

ENDIF2:			;incrementa ponteiro
	LDA PTR
	ADD #1
	STA PTR
	LDA PTR+1
	ADC #0
	STA PTR+1

	LDA J		;incrementa contador
	ADD #1
	STA J
	JMP LOOP2

END2:
	LDA PTR		;reseta o ponteiro
	SUB #5
	STA PTR
	LDA PTR+1
	SBC #0
	STA PTR+1

	LDA @ADRL	;desloca parte baixa
	SHL
	STA @ADRL

	LDA #0		;salva carry
	ADC #0
	STA BIT

	LDA @ADRH	;desloca parte alta
	SHL			;OR BIT (bug: OR altera carry)
	STA @ADRH

	LDA #0		;salva carry temporariamente
	ADC #0
	STA TEMP

	LDA @ADRH	;adiciona bit ao valor
	OR BIT
	STA @ADRH

	LDA TEMP	;salva carry como bit
	STA BIT

	LDA #0		;carrega contador
	STA J
LOOP3:			;while (k < 5)
	SUB #5
	JZ END3

	LDA @PTR	;desloca digito
	SHL			;OR BIT
	OR BIT
	STA @PTR

	AND #10h	;salva carry
	SHR
	SHR
	SHR
	SHR
	STA BIT

	LDA PTR		;incrementa ponteiro
	ADD #1
	STA PTR
	LDA PTR+1
	ADC #0
	STA PTR+1

	LDA J		;incrementa contador
	ADD #1
	STA J
	JMP LOOP3

END3:
	LDA PTR		;reseta ponteiro
	SUB #5
	STA PTR
	LDA PTR+1
	SBC #0
	STA PTR+1

	LDA I		;incrementa contador
	ADD #1
	STA I
	JMP LOOP1

END1:
	LDA #0		;reseta contador
	STA I
LOOP4:
	SUB #5
	JZ END4

	LDA @PTR	;converte para ascii
	AND #0Fh
	ADD #30h
	STA @PTR

	LDA PTR		;incrementa ponteiro
	ADD #1
	STA PTR
	LDA PTR+1
	ADC #0
	STA PTR+1

	LDA I		;incrementa variavel
	ADD #1
	STA I
	JMP LOOP4

END4:
	OUT 3		;limpa banner

	LDA SIGN	;imprime sinal
	OUT 2

	LDA #0		;reseta contador
	STA I
LOOP5:
	SUB #5
	JZ END5

	LDA PTR		;diminui ponteiro
	SUB #1
	STA PTR
	LDA PTR+1
	SBC #0
	LDA PTR+1

	LDA @PTR	;imprime caractere
	OUT 2

	LDA I		;incrementa contador
	ADD #1
	STA I
	JMP LOOP5

END5:
	LDA STP+1	;recoloca endereco de retorno e retorna
	PUSH
	LDA STP
	PUSH
	RET

STP:			;endereco de retorno
	DW 0
ADRL:			;endereco baixo da variavel
	DW 0
ADRH:			;endereco alto da variavel
	DW 0
SIGN:			;sinal em ascii
	DB 2Bh
DIGITS:			;digitos convertidos
	DB 0, 0, 0, 0, 0
PTR:			;ponteiro para digitos
	DW DIGITS
BIT:			;bit restante do shift
	DB 0
I:				;variavel do loop externo
	DB 0
J:				;variavel do loop interno
	DB 0
TEMP:
	DB 0


ORG 200h
TWOS:				;entrada: endereco do numero a ser convertido
	POP				;salva endereco de retorno
	STA STP2
	POP
	STA STP2+1

	POP				;salva endereco do numero
	STA ADR
	POP
	STA ADR+1

	LDA @ADR		;converte parte baixa
	NOT
	ADD #1
	STA @ADR

	LDA #0			;salva carry
	ADC #0
	STA CARRY

	LDA ADR			;incrementa endereco
	ADD #1
	STA	ADR
	LDA ADR+1
	ADC #0
	STA ADR+1

	LDA 0FFh		;restaura o carry
	ADD CARRY

	LDA @ADR		;converte parte alta
	NOT
	ADC #0
	STA @ADR

	LDA STP2+1		;carrega endereço de retorno
	PUSH
	LDA STP2
	PUSH
	RET

STP2:
	DW 0
ADR:
	DW 0
CARRY:
	DB 0


ORG 300h
	DW 0010h
