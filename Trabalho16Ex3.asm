.macro endProgram # encerra o programa
	li $v0, 10
	syscall
.end_macro
	
.macro printInt (%int) # salva em $a0 o valor fornecido no parâmetro como inteiro e imprime-o
	la $a0, (%int)
	li $v0, 1 # código de impressão de inteiro
	syscall
.end_macro

.macro printString (%str) # imprime diretamente a string inserida como parâmetro
	.data
		macroLabel: .asciiz %str
	.text
		li $v0, 4 # código de impressão de String
		la $a0, macroLabel
		syscall
.end_macro

.macro newline # quebra linha
	li $a0, 10 # Código ASCII para ("\n")	
	li $v0, 11 # Código de impressão de caractere
	syscall
.end_macro
	
.macro readInt # lê um inteiro inserido pelo usuário e salva em $v0
	li $v0, 5
	syscall
.end_macro

.text
	
	Main:
		
		printString("Insira o número inteiro positivo, o qual se deseja calcular o Hiperfatorial: ")
		readInt
		la $a1, ($v0)
		
		jal Hiperfatorial
		
		newline
		printString("O hiperfatorial de ")
		printInt($a1)
		printString(" é igual a: ")
		printInt($v1)
		
		endProgram
		
	Hiperfatorial: # Recebe em $a1 um número inteiro possitivo e retorna em $v1 seu hiperfatorial
		# $t0 -> contador decrescente da função fatorial
		# $t1 -> registrador auxiliar
		# $t2 -> contador de repetições do loopInternoHiperfatorial
		bltz $a1, entradaInvalidaHiperfatorial # Se o número inserido for negativo não é possível calcular o fatorial desse número
		beqz $a1, entradaZeroHiperfatorial # Se o valor de entrada for 0, utiliza-se a regra especial de que 0! = 1
		li $v1, 1 # Incia o retorno do fatorial com 1
		la $t0, ($a1) # Incia o contador decrescente $t0 com o valor recebido de entrada 
		loopHiperfatorial:
			la $t2, ($zero) # Inicia o contador de repetições do loopInternoHiperfatorial $t2 com 0 
			li $t1, 1 # Inicia com 1 o registrador auxiliar
			loopInternoHiperfatorial: # Realiza a operação n^n
				mulo $t1, $t1, $t0 # Multiplica por $t0 o valor total de $t0
				addi $t2, $t2, 1 # Incrementa em 1 o valor do contador de repetições do loopInternoHiperfatorial $t2
				blt $t2, $t0, loopInternoHiperfatorial # Enquanto o contador de repetições do loop for menor que o valor de $t0 repete o loopInternoHiperfatorial
			mulo $v1, $v1, $t1 # Multiplica o valor de $v1 pelo valor atual do contador $t0
			subi $t0, $t0, 1 # decrementa o contador $t0 em 1
			bgt $t0, 1, loopHiperfatorial # Enquanto o valor de $t0 for maior que 1 repete o loopHiperfatorial 
		jr $ra
		entradaZeroHiperfatorial:
			li $v1, 1 # Salva o registrador de retorno $v1 como 1, pois por definição 0! = 1
			jr $ra
		entradaInvalidaHiperfatorial:
			printString("Entrada inválida.")
			endProgram
	
