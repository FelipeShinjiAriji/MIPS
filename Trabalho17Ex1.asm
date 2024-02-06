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

.macro endProgram # encerra o programa
	li $v0, 10
	syscall
.end_macro
	
.macro printInt (%int) # salva em $a0 o valor fornecido no parâmetro como inteiro e imprime-o
	la $a0, (%int)
	li $v0, 1 # código de impressão de inteiro
	syscall
.end_macro

.macro newline # quebra linha
	li $a0, 10 # Código ASCII para ("\n")	
	li $v0, 11 # Código de impressão de caractere
	syscall
.end_macro

.macro printInt # imprime o inteiro do registrador $a0
	li $v0, 1
	syscall
.end_macro

.data

	vetorEntradaA: .space 80
	vetorEntradaB: .space 80

.text
	
	Main:
		printString("Insira a quantidade de elementos dos vetores a serem multiplicados: ")
		readInt
		la $a2, ($v0)
		
		printString("Preencha o primeiro vetor: ")
		newline
		la $a1, vetorEntradaA
		jal lerInteirosPositivos
		jal printVetorInt
		
		printString("Preencha o primeiro vetor: ")
		newline
		la $a1, vetorEntradaB
		jal lerInteirosPositivos
		jal printVetorInt
		
		la $a3, ($a2)
		la $a2, vetorEntradaA
		jal produtoEscalar2Vetores
		
		printString("O produto escalar desses vetores é: ")
		printInt($v1)
		endProgram
		
	produtoEscalar2Vetores: # Recebe o endereço do primeiro elemento de um vetor em $a1, o de outro de mesmo comprimento em $a2 e o comprimento deles em $a3, retorna em $v1 o produto escalar desses vetores
		# $t0 -> ponteiro para o primeiro vetor de entrada
		# $t1 -> registrador do valor do elemento apontado pelo ponteiro $t0
		# $t2 -> ponteiro para o segundo vetor de entrada
		# $t3 -> registrador do valor do elemento apontado pelo ponteiro $t2
		# $t4 -> contador da quantidade de elementos já processados de cada vetor
		# $t5 -> registrador auxiliar, que armazena a operação de multiplicação presente na produto escalar
		la $v1, ($zero) # Inicia com 0 o registrador de retorno do produto escalar em 0
		la $t0, ($a1) # Carrega o endereço do primeiro elemento do primeiro vetor de entrada no ponteiro $t0
		la $t2, ($a2) # Carrega o endereço do primeiro elemento do segundo vetor de entrada no ponteiro $t2
		la $t4, ($zero) # Inicia o contador da quantidade de elementos já processados de cada vetor $t4 com 0
		loopProdutoEscalar2Vetores:
			lw $t1, ($t0) # Armazena em $t1 o valor do elemento apontado pelo ponteiro $t0
			lw $t3, ($t2) # Armazena em $t3 o valor do elemento apontado pelo ponteiro $t2
			mulo $t5, $t1, $t3 # Multiplica $t1 por $t3 e armazena em $t5
			add $v1, $v1, $t5 # Soma ao total do produto escalar de retorno $v1 o resultado da multiplicação acima
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o próximo elemento do primeiro vetor de entrada
			addi $t2, $t2, 4 # Incrementa o ponteiro $t2 para o próximo elemento do segundo vetor de entrada
			addi $t4, $t4, 1 # Incrementa o contador da quantidade de elementos já processados de cada vetor $t4 em 1
			blt $t4, $a3, loopProdutoEscalar2Vetores # Enquanto a quantidade de elementos já processados de cada vetor for menor que a quantidade de elementos dos vetores repete o loopProdutoEscalar2Vetores 
		jr $ra
		
	lerInteirosPositivos: # Recebe o endereço de um vetor para preencher em $a1 e lê a quantidade de números inteiros positivos do usuário equivalente ao valor recebido em $a2, salvando-os no vetor recebido
		# $t0 -> ponteiro para o próximo espaço vazio do vetor
		# $t1 -> contador de valores recebidos pelo usuário
		la $t1, ($zero) # Zera o registrador da quantidade de números lidos $t1
		la $t0, ($a1) # Aponta o ponteiro $t0 para o primeiro espaço livre do vetor
		loopLerInteirosPositivos:
			printString("Insira o próximo número a ser inserido no vetor: ")
			readInt
			addi $t1, $t1, 1 # incrementa a quantidade de n números inteiros positivos lidos em $t1
			sw $v0, ($t0) # Armazena o valor recebido pelo usuário no próximo espaço vazio do vetor
			addi $t0, $t0, 4 # incrementa o ponteiro $t0 para o próximo espaço vazio do vetor
			blt $t1, $a2,  loopLerInteirosPositivos # Enquanto o número de elementos lidos for menor do que 15 repete o loopLerInteiros
		jr $ra
		
	printVetorInt: #  Recebe o endereço do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e imprime todos os números do vetor
		# $t0 -> Ponteiro para o elemento atualmente avaliado
		# $t1 -> contador de números impressos
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
