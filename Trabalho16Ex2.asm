.macro endProgram # encerra o programa
	li $v0, 10
	syscall
.end_macro

.macro readInt # lê um inteiro inserido pelo usuário e salva em $v0
	li $v0, 5
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

.macro printInt # imprime o inteiro do registrador $a0
	li $v0, 1
	syscall
.end_macro

.macro newline # quebra linha
	li $a0, 10 # Código ASCII para ("\n")	
	li $v0, 11 # Código de impressão de caractere
	syscall
.end_macro

.data
	
	vetorRetornoEncontraNPrimeirosMultiplosDeAeB: .space 100

.text
	
	Main:
		
		printString("Insira a quantidade de números de resposta desejado: ")
		readInt
		la $a1, ($v0)
		printString("Insira o primeiro número para serem buscados seus múltiplos: ")
		readInt
		la $a2, ($v0)
		printString("Insira o segundo número para serem buscados seus múltiplos: ")
		readInt
		la $a3, ($v0)
		
		la $a0, vetorRetornoEncontraNPrimeirosMultiplosDeAeB
		jal encontraNPrimeirosMultiplosDeAeB
		
		la $a2, ($a1)
		la $a1, vetorRetornoEncontraNPrimeirosMultiplosDeAeB
		jal printVetorInt
		
		endProgram

	encontraNPrimeirosMultiplosDeAeB: # Recebe em $a1 o comprimento da subconjunto de múltiplos positivos desejado, em $a2 um número inteiro positivo, outro em $a3 e preenche vetor passado em $a0 com os $a1 primeiros múltiplos de $a2 e/ou $a3
		# $t0 -> ponteiro para o vetor de retorno
		# $t1 -> número atualmente testado para verificar se é múltiplo
		# $t2 -> contador de números inseridos no vetor de retorno
		# $t3 -:> armazena o resto da divisão para testar se é múltiplo
		la $t0, ($a0) # Carrega em $t0 o endereço do primeiro elemento vazio do vetor de retorno
		la $t1, ($zero) # Inicia o registrador com o número a ser testado 0
		la $t1, ($zero) # Inicia o contador com da quantidade de números inseridos no vetor de retorno com 0
		loopEncontraNPrimeirosMultiplosDeAeB:
			addi $t1, $t1, 1 # Incrementa em 1 o número testado para o próximo número
			div $t1, $a2 # Divide o valor de $t1 por $a2
			mfhi $t3 # Move o resto da divisão acima em $t3
			beqz $t3, acertoEncontraNPrimeirosMultiplosDeAeB # Se o valor do resto da divisão for igual a 0 o número registrado em $t1 é múltiplo do número em $a2, então vai para acertoEncontraNPrimeirosMultiplosDeAeB
				div $t1, $a3 # Se não testa para o $a3, então divide o valor de $t1 por $a3
				mfhi $t3 # Move o resto da divisão acima em $t3
				beqz $t3, acertoEncontraNPrimeirosMultiplosDeAeB # Se o valor do resto da divisão for igual a 0 o número registrado em $t1 é múltiplo do número em $a3, então vai para acertoEncontraNPrimeirosMultiplosDeAeB
					j loopEncontraNPrimeirosMultiplosDeAeB # Se não reinicia o loopEncontraNPrimeirosMultiplosDeAeB sem realizar o bloco acertoEncontraNPrimeirosMultiplosDeAeB
			acertoEncontraNPrimeirosMultiplosDeAeB:
				sw $t1, ($t0) # Se não o valor de $t1 é multiplo do valor de $a2 e por isso é armazenado no vetor
				addi $t0, $t0, 4 # Incrementa o ponteiro para o próximo elemento vazio do vetor de retorno
				addi $t2, $t2, 1 # Incrementa o contador de números armazenados no vetor de retorno em 1
				blt  $t2, $a1 loopEncontraNPrimeirosMultiplosDeAeB # Enquanto a quantidade de números inseridos no vetor de retorno for menor que o desejado inserido em $a1 repete o loopEncontraNPrimeirosMultiplosDeAeB
		jr $ra

	printVetorInt: #  Recebe o endereço do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e imprime todos os números do vetor
		# $t0 -> Ponteiro para o elemento atualmente avaliado
		# $t1 -> contador de números impressos
		# $a0 -> Valor a ser impresso
		ble $a2, $zero, endPrintVetorInt # Se o comprimento do vetor for menor ou igual a 0, a função é cancelada
		la $t1, ($zero) # Inicia o contador de números impressos $t1 com 0
		la $t0, ($a1) # Carrega em $t0 o endereço do primeiro elemento do vetor 
		loopPrintVetorInt:
			lw $a0, ($t0) # Carrega em $a0 o valor a ser impresso
			printInt
			newline
			addi $t0, $t0, 4 # Incrementa o ponteiro para o próximo elemento do vetor
			addi $t1, $t1, 1 # Incremenra o contador de números impressos
			blt $t1, $a2, loopPrintVetorInt # Enquanto o valor do contador de números impressos for menor que o comprimento do vetor repete o loopPrintVetorInt
		endPrintVetorInt:
		jr $ra