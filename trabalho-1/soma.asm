ORG 0
	LDA #01H
	PUSH
	LDA #04H
	PUSH
	LDA #01H
	PUSH
	LDA #02H
	PUSH
	LDA #01H
	PUSH
	LDA #00H
	PUSH
	LDA #0
	PUSH
	JSR SOMA
    HLT
END 0


ORG 20H
SOMA:			;entrada: operacao, entrada 1, entrada 2, saida. retorno: carry
	POP			;salva endereço de retorno
	STA STP
	POP
	STA STP+1

	POP			;salva operacao
	STA OPR

	POP			;salva endereco da variavel 1
	STA END1
	POP
	STA END1+1

	POP			;salva endereco da variavel 2
	STA END2
	POP
	STA END2+1

	POP			;salva endereco da saida
	STA END3
	POP
	STA END3+1

	LDA OPR		;escolhe operacao
	JNZ SUBL

	LDA @END1	;realiza soma da parte baixa
	ADD @END2
	STA @END3
	JMP ENDL

SUBL:			;realiza subtracao da parte baixa
	LDA @END1
	SUB @END2
	STA @END3

ENDL:			;salva carry
	LDA #0
	ADC #0
	STA CARRY

	LDA END1	;incrementa enderecos
	ADD #1
    STA END1
	LDA END1+1
	ADC #0
    STA END1+1
	LDA END2
	ADD #1
    STA END2
	LDA END2+1
	ADC #0
    LDA END2+1
	LDA END3
	ADD #1
    STA END3
	LDA END3+1
	ADC #0
    LDA END3+1

	LDA #0FFH	;coloca carry de volta na flag
	ADD CARRY

	LDA OPR		;escolhe operacao
	JNZ SUBH

	LDA @END1	;realiza soma da parte alta
	ADC @END2
	STA @END3
	JMP ENDH

SUBH:			;realiza subtracao da parte alta
	LDA @END1
	SBC @END2
	STA @END3

ENDH:			;coloca carry na pilha para retorno
	LDA #0
	ADC #0
	PUSH

	LDA STP+1	;carrega endereço de retorno
	PUSH
	LDA STP
	PUSH
	RET

STP:			;endereco de retorno
	DW 0
OPR:			;flag da operacao
	DB 0
END1:			;endereco da variavel 1
	DW 0
END2:			;endereco da variavel 2
	DW 0
END3:			;endereco de saida
	DW 0
CARRY:			;carry da parte baixa
	DB 0


ORG 100H
IN1:
	DB 10H, 10H	;entrada 1
IN2:
	DB 10H, 10H	;entrada 2
OUT:
	DS 2		;saida

