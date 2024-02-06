.macro endProgram # encerra o programa
	li $v0, 10
	syscall
.end_macro

.macro readInt # l� um inteiro inserido pelo usu�rio e salva em $v0
	li $v0, 5
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

.macro printInt # imprime o inteiro do registrador $a0
	li $v0, 1
	syscall
.end_macro

.macro newline # quebra linha
	li $a0, 10 # C�digo ASCII para ("\n")	
	li $v0, 11 # C�digo de impress�o de caractere
	syscall
.end_macro

.data
	
	vetorRetornoEncontraNPrimeirosMultiplosDeAeB: .space 100

.text
	
	Main:
		
		printString("Insira a quantidade de n�meros de resposta desejado: ")
		readInt
		la $a1, ($v0)
		printString("Insira o primeiro n�mero para serem buscados seus m�ltiplos: ")
		readInt
		la $a2, ($v0)
		printString("Insira o segundo n�mero para serem buscados seus m�ltiplos: ")
		readInt
		la $a3, ($v0)
		
		la $a0, vetorRetornoEncontraNPrimeirosMultiplosDeAeB
		jal encontraNPrimeirosMultiplosDeAeB
		
		la $a2, ($a1)
		la $a1, vetorRetornoEncontraNPrimeirosMultiplosDeAeB
		jal printVetorInt
		
		endProgram

	encontraNPrimeirosMultiplosDeAeB: # Recebe em $a1 o comprimento da subconjunto de m�ltiplos positivos desejado, em $a2 um n�mero inteiro positivo, outro em $a3 e preenche vetor passado em $a0 com os $a1 primeiros m�ltiplos de $a2 e/ou $a3
		# $t0 -> ponteiro para o vetor de retorno
		# $t1 -> n�mero atualmente testado para verificar se � m�ltiplo
		# $t2 -> contador de n�meros inseridos no vetor de retorno
		# $t3 -:> armazena o resto da divis�o para testar se � m�ltiplo
		la $t0, ($a0) # Carrega em $t0 o endere�o do primeiro elemento vazio do vetor de retorno
		la $t1, ($zero) # Inicia o registrador com o n�mero a ser testado 0
		la $t1, ($zero) # Inicia o contador com da quantidade de n�meros inseridos no vetor de retorno com 0
		loopEncontraNPrimeirosMultiplosDeAeB:
			addi $t1, $t1, 1 # Incrementa em 1 o n�mero testado para o pr�ximo n�mero
			div $t1, $a2 # Divide o valor de $t1 por $a2
			mfhi $t3 # Move o resto da divis�o acima em $t3
			beqz $t3, acertoEncontraNPrimeirosMultiplosDeAeB # Se o valor do resto da divis�o for igual a 0 o n�mero registrado em $t1 � m�ltiplo do n�mero em $a2, ent�o vai para acertoEncontraNPrimeirosMultiplosDeAeB
				div $t1, $a3 # Se n�o testa para o $a3, ent�o divide o valor de $t1 por $a3
				mfhi $t3 # Move o resto da divis�o acima em $t3
				beqz $t3, acertoEncontraNPrimeirosMultiplosDeAeB # Se o valor do resto da divis�o for igual a 0 o n�mero registrado em $t1 � m�ltiplo do n�mero em $a3, ent�o vai para acertoEncontraNPrimeirosMultiplosDeAeB
					j loopEncontraNPrimeirosMultiplosDeAeB # Se n�o reinicia o loopEncontraNPrimeirosMultiplosDeAeB sem realizar o bloco acertoEncontraNPrimeirosMultiplosDeAeB
			acertoEncontraNPrimeirosMultiplosDeAeB:
				sw $t1, ($t0) # Se n�o o valor de $t1 � multiplo do valor de $a2 e por isso � armazenado no vetor
				addi $t0, $t0, 4 # Incrementa o ponteiro para o pr�ximo elemento vazio do vetor de retorno
				addi $t2, $t2, 1 # Incrementa o contador de n�meros armazenados no vetor de retorno em 1
				blt  $t2, $a1 loopEncontraNPrimeirosMultiplosDeAeB # Enquanto a quantidade de n�meros inseridos no vetor de retorno for menor que o desejado inserido em $a1 repete o loopEncontraNPrimeirosMultiplosDeAeB
		jr $ra

	printVetorInt: #  Recebe o endere�o do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e imprime todos os n�meros do vetor
		# $t0 -> Ponteiro para o elemento atualmente avaliado
		# $t1 -> contador de n�meros impressos
		# $a0 -> Valor a ser impresso
		ble $a2, $zero, endPrintVetorInt # Se o comprimento do vetor for menor ou igual a 0, a fun��o � cancelada
		la $t1, ($zero) # Inicia o contador de n�meros impressos $t1 com 0
		la $t0, ($a1) # Carrega em $t0 o endere�o do primeiro elemento do vetor 
		loopPrintVetorInt:
			lw $a0, ($t0) # Carrega em $a0 o valor a ser impresso
			printInt
			newline
			addi $t0, $t0, 4 # Incrementa o ponteiro para o pr�ximo elemento do vetor
			addi $t1, $t1, 1 # Incremenra o contador de n�meros impressos
			blt $t1, $a2, loopPrintVetorInt # Enquanto o valor do contador de n�meros impressos for menor que o comprimento do vetor repete o loopPrintVetorInt
		endPrintVetorInt:
		jr $ra