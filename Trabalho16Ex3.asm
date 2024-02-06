.macro endProgram # encerra o programa
	li $v0, 10
	syscall
.end_macro
	
.macro printInt (%int) # salva em $a0 o valor fornecido no par�metro como inteiro e imprime-o
	la $a0, (%int)
	li $v0, 1 # c�digo de impress�o de inteiro
	syscall
.end_macro

.macro printString (%str) # imprime diretamente a string inserida como par�metro
	.data
		macroLabel: .asciiz %str
	.text
		li $v0, 4 # c�digo de impress�o de String
		la $a0, macroLabel
		syscall
.end_macro

.macro newline # quebra linha
	li $a0, 10 # C�digo ASCII para ("\n")	
	li $v0, 11 # C�digo de impress�o de caractere
	syscall
.end_macro
	
.macro readInt # l� um inteiro inserido pelo usu�rio e salva em $v0
	li $v0, 5
	syscall
.end_macro

.text
	
	Main:
		
		printString("Insira o n�mero inteiro positivo, o qual se deseja calcular o Hiperfatorial: ")
		readInt
		la $a1, ($v0)
		
		jal Hiperfatorial
		
		newline
		printString("O hiperfatorial de ")
		printInt($a1)
		printString(" � igual a: ")
		printInt($v1)
		
		endProgram
		
	Hiperfatorial: # Recebe em $a1 um n�mero inteiro possitivo e retorna em $v1 seu hiperfatorial
		# $t0 -> contador decrescente da fun��o fatorial
		# $t1 -> registrador auxiliar
		# $t2 -> contador de repeti��es do loopInternoHiperfatorial
		bltz $a1, entradaInvalidaHiperfatorial # Se o n�mero inserido for negativo n�o � poss�vel calcular o fatorial desse n�mero
		beqz $a1, entradaZeroHiperfatorial # Se o valor de entrada for 0, utiliza-se a regra especial de que 0! = 1
		li $v1, 1 # Incia o retorno do fatorial com 1
		la $t0, ($a1) # Incia o contador decrescente $t0 com o valor recebido de entrada 
		loopHiperfatorial:
			la $t2, ($zero) # Inicia o contador de repeti��es do loopInternoHiperfatorial $t2 com 0 
			li $t1, 1 # Inicia com 1 o registrador auxiliar
			loopInternoHiperfatorial: # Realiza a opera��o n^n
				mulo $t1, $t1, $t0 # Multiplica por $t0 o valor total de $t0
				addi $t2, $t2, 1 # Incrementa em 1 o valor do contador de repeti��es do loopInternoHiperfatorial $t2
				blt $t2, $t0, loopInternoHiperfatorial # Enquanto o contador de repeti��es do loop for menor que o valor de $t0 repete o loopInternoHiperfatorial
			mulo $v1, $v1, $t1 # Multiplica o valor de $v1 pelo valor atual do contador $t0
			subi $t0, $t0, 1 # decrementa o contador $t0 em 1
			bgt $t0, 1, loopHiperfatorial # Enquanto o valor de $t0 for maior que 1 repete o loopHiperfatorial 
		jr $ra
		entradaZeroHiperfatorial:
			li $v1, 1 # Salva o registrador de retorno $v1 como 1, pois por defini��o 0! = 1
			jr $ra
		entradaInvalidaHiperfatorial:
			printString("Entrada inv�lida.")
			endProgram
	
