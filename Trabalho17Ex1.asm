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

.macro endProgram # encerra o programa
	li $v0, 10
	syscall
.end_macro
	
.macro printInt (%int) # salva em $a0 o valor fornecido no par�metro como inteiro e imprime-o
	la $a0, (%int)
	li $v0, 1 # c�digo de impress�o de inteiro
	syscall
.end_macro

.macro newline # quebra linha
	li $a0, 10 # C�digo ASCII para ("\n")	
	li $v0, 11 # C�digo de impress�o de caractere
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
		
		printString("O produto escalar desses vetores �: ")
		printInt($v1)
		endProgram
		
	produtoEscalar2Vetores: # Recebe o endere�o do primeiro elemento de um vetor em $a1, o de outro de mesmo comprimento em $a2 e o comprimento deles em $a3, retorna em $v1 o produto escalar desses vetores
		# $t0 -> ponteiro para o primeiro vetor de entrada
		# $t1 -> registrador do valor do elemento apontado pelo ponteiro $t0
		# $t2 -> ponteiro para o segundo vetor de entrada
		# $t3 -> registrador do valor do elemento apontado pelo ponteiro $t2
		# $t4 -> contador da quantidade de elementos j� processados de cada vetor
		# $t5 -> registrador auxiliar, que armazena a opera��o de multiplica��o presente na produto escalar
		la $v1, ($zero) # Inicia com 0 o registrador de retorno do produto escalar em 0
		la $t0, ($a1) # Carrega o endere�o do primeiro elemento do primeiro vetor de entrada no ponteiro $t0
		la $t2, ($a2) # Carrega o endere�o do primeiro elemento do segundo vetor de entrada no ponteiro $t2
		la $t4, ($zero) # Inicia o contador da quantidade de elementos j� processados de cada vetor $t4 com 0
		loopProdutoEscalar2Vetores:
			lw $t1, ($t0) # Armazena em $t1 o valor do elemento apontado pelo ponteiro $t0
			lw $t3, ($t2) # Armazena em $t3 o valor do elemento apontado pelo ponteiro $t2
			mulo $t5, $t1, $t3 # Multiplica $t1 por $t3 e armazena em $t5
			add $v1, $v1, $t5 # Soma ao total do produto escalar de retorno $v1 o resultado da multiplica��o acima
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o pr�ximo elemento do primeiro vetor de entrada
			addi $t2, $t2, 4 # Incrementa o ponteiro $t2 para o pr�ximo elemento do segundo vetor de entrada
			addi $t4, $t4, 1 # Incrementa o contador da quantidade de elementos j� processados de cada vetor $t4 em 1
			blt $t4, $a3, loopProdutoEscalar2Vetores # Enquanto a quantidade de elementos j� processados de cada vetor for menor que a quantidade de elementos dos vetores repete o loopProdutoEscalar2Vetores 
		jr $ra
		
	lerInteirosPositivos: # Recebe o endere�o de um vetor para preencher em $a1 e l� a quantidade de n�meros inteiros positivos do usu�rio equivalente ao valor recebido em $a2, salvando-os no vetor recebido
		# $t0 -> ponteiro para o pr�ximo espa�o vazio do vetor
		# $t1 -> contador de valores recebidos pelo usu�rio
		la $t1, ($zero) # Zera o registrador da quantidade de n�meros lidos $t1
		la $t0, ($a1) # Aponta o ponteiro $t0 para o primeiro espa�o livre do vetor
		loopLerInteirosPositivos:
			printString("Insira o pr�ximo n�mero a ser inserido no vetor: ")
			readInt
			addi $t1, $t1, 1 # incrementa a quantidade de n n�meros inteiros positivos lidos em $t1
			sw $v0, ($t0) # Armazena o valor recebido pelo usu�rio no pr�ximo espa�o vazio do vetor
			addi $t0, $t0, 4 # incrementa o ponteiro $t0 para o pr�ximo espa�o vazio do vetor
			blt $t1, $a2,  loopLerInteirosPositivos # Enquanto o n�mero de elementos lidos for menor do que 15 repete o loopLerInteiros
		jr $ra
		
	printVetorInt: #  Recebe o endere�o do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e imprime todos os n�meros do vetor
		# $t0 -> Ponteiro para o elemento atualmente avaliado
		# $t1 -> contador de n�meros impressos
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
