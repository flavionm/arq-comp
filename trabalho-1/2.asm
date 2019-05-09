;---------------------------------------------------
; Programa:
; Autor:
; Data:
;---------------------------------------------------
ORG 0
     LDA #01H
     PUSH
     LDA #00H
     PUSH
     JSR MULT
     HLT
END 0

ORG 100H
     DW 0F00Fh

ORG 20H
MULT:          ; Entrada: Endereco do resultado
     POP       ; Salva endereco de retorno
     STA RES
     POP
     STA RES+1

     POP       ; Salva endereco da variavel
     STA VAR
     POP
     STA VAR+1

     LDA VAR
     SHL      ; RES = 8*VAR
     SHL
     SHL
     STA RES
     LDA VAR+1
     SHL
     SHL
     SHL
     STA RES+1

     LDA RES   ; RES = 8*VAR + VAR + VAR
     ADD VAR
     ADD VAR
     STA RES
     LDA RES+1
     ADD VAR+1
     ADD VAR+1
     STA RES+1

     LDA RES+1 ; Carrega endereco de retorno
     PUSH
     LDA RES
     PUSH
     RET

RES: DW 0      ; Endereco de retorno

VAR: DW 0      ; Endereco da variavel
