ORG 0
	LDA #01h
	PUSH
	LDA #00h
	PUSH
	JSR TWOS
	HLT
END 0


ORG 20h
TWOS:				;entrada: endereco do numero a ser convertido
	POP				;salva endereco de retorno
	STA STP
	POP
	STA STP+1

	POP				;salva endereco do numero
	STA END
	POP
	STA END+1

	LDA @END		;converte parte baixa
	NOT
	ADD #1
	STA @END

	LDA #0			;salva carry
	ADC #0
	STA CARRY

	LDA END			;incrementa endereco
	ADD #1
	STA	END
	LDA END+1
	ADC #0
	STA END+1

	LDA 0FFh		;restaura o carry
	ADD CARRY

	LDA @END		;converte parte alta
	NOT
	ADC #0
	STA @END

	LDA STP+1		;carrega endereço de retorno
	PUSH
	LDA STP
	PUSH
	RET

STP:
	DW 0
END:
	DW 0
CARRY:
	DB 0


ORG 100h
	DB 01h, 00h
