.macro endProgram # encerra o programa
	li $v0, 10
	syscall
.end_macro

.macro newline # quebra linha
	li $a0, 10 # C�digo ASCII para ("\n")	
	li $v0, 11 # C�digo de impress�o de caractere
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

.macro readInt # l� um inteiro inserido pelo usu�rio e salva em $v0
	li $v0, 5
	syscall
.end_macro

.macro printInt # imprime o inteiro do registrador $a0
	li $v0, 1
	syscall
.end_macro

.data

	vetorEntrada: .space 12
	vetorSaida: .space 16
	matrixEntrada: .space 48 # 4x3 * 4 (inteiro)
	Ent1: .asciiz " Insira o valor de Mat["
	Ent2: .asciiz "]["
	Ent3: .asciiz "]: "

.text
	
	Main:
	
		
		
		printString("Preencha a matrix A: ")
		newline
		
		la $a0, matrixEntrada # Endere�o base de Mat
		li $a1, 4 # N�mero de linhas
		li $a2, 3 # N�mero de colunas
		jal leitura # leitura(mat, nlin, ncol)
		move $a0, $v0 # Endere�o da matriz lida
		jal escrita # escrita(mat, nlin, ncol)
		
		printString("Preencha o vetor V: ")
		newline
		
		la $a1, vetorEntrada
		li $a2, 3
		jal lerInteirosPositivos
		jal printVetorInt
		
		la $a1, matrixEntrada
		la $a2, vetorEntrada
		la $a3, vetorSaida
		jal produtoMatricial
		
		newline
		printString("O produto A * V = ")
		newline
		la $a1, vetorSaida
		li $a2, 4
		jal printVetorInt
		
		endProgram
		
	produtoMatricial: # Recebe em $a1 o endere�o do primeiro elemento de uma matriz 4*3, em $a2 o endere�o do primeiro elemento do vetor de entrada 3*1 e em $a3 o endere�o de um espa�o de 16 bytes para salvar o vetor de sa�da, que ser� resultado do produto do vetor de entrada pela matriz de entrada
		# $t0 -> ponteiro para a matriz de entrada
		# $t1 -> valor do elemento apontado pelo ponteiro $t0
		# $t2 -> ponteiro para o vetor de entrada
		# $t3 -> valor do elemento apontado pelo ponteiro $t3
		# $t4 -> ponteiro para o vetor de sa�da
		# $t5 -> valor do elemento a ser armazenado no vetor de sa�da
		# $t6 -> contador de colunas percorridas na matriz
		# $t7 -> contador de linhas percorridas na matriz
		# $t9 -> registrador auxiliar da multiolica��o para a opera��o de criar o elemento do vetor de sa�da
		la $t0, ($a1) # Carrega o ponteiro $t0 com o endere�o do primeiro elemento da matriz de entrada
		la $t4, ($a3) # Carrega o ponteiro $t4 com o endere�o do primeiro elemento do vetor de sa�da
		la $t7, ($zero) # Inicia o contador de linhas percorridas na matriz $t7 com 0
		loopColunaProdutoMatricial:
			la $t2, ($a2) # Carrega o ponteiro $t2 com o endere�o do primeiro elemento do vetor de entrada
			la $t5, ($zero) # Inicia o valor $t5 a ser salvo no vetor de sa�da com 0
			la $t6, ($zero) # Inicia o contador de colunas percorridas na matriz $t6 com 0
			loopLinhaProdutoMatricial:
				lw $t1, ($t0) # Carrega em $t1 o valor do elemento apontado pelo ponteiro $t0
				lw $t3, ($t2) # Carrega em $t3 o valor do elemento apontado pelo ponteiro $t2
				mulo $t9, $t1, $t3 # Salva em $t9 o valor do produto de $t1 * $t3
				add $t5, $t5, $t9 # Soma ao total armazenado em $t5 com o valor da multiplica��o anterior
				addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o pr�ximo elemento da matriz de entrada
				addi $t2, $t2, 4 # Incrementa o ponteiro $t2 para o pr�ximo elemento do vetor de entrada
				addi $t6, $t6, 1 # Incrementa o contador de colunas percorridas na matriz em 1
				blt $t6, 3, loopLinhaProdutoMatricial # Enquanto o n�mero de colunas percorridas na matriz for menor que a quantidade de colunas da matriz repete o loopLinhaProdutoMatricial
			sw $t5, ($t4) # Armazena o conte�do de $t5 no pr�ximo elemento vazio, apontado por $t4, do vetor de sa�da
			addi $t4, $t4, 4 # Incrementa o ponteiro para o vetor de sa�da $t4para o pr�ximo elemento
			addi $t7, $t7, 1 # Incrementa o contador da quantidade de linhas percorridas na matriz $t7 em 1
			blt $t7, 4, loopColunaProdutoMatricial # Enquanto o n�mero de linhas percorridas na matriz fot menor que a quantidade de linhas da matriz repete o loopColunaProdutoMatricial
			
			
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
	
	
	indice:
		mul $v0, $t0, $a2 # i * ncol
		add $v0, $v0, $t1 # (i * ncol) + j
		sll $v0, $v0, 2 # [(i * ncol) + j] * 4 (inteiro)
		add $v0, $v0, $a3 # Soma o endere�o base de mat
		jr $ra # Retorna para o caller
	
	leitura:
		subi $sp, $sp, 4 # Espa�o para 1 item na pilha
		sw $ra, ($sp) # Salva o retorno para a main
		move $a3, $a0 # aux = endere�o base de mat
		l: la $a0, Ent1 # Carrega o endere�o da string
		li $v0, 4 # C�digo de impress�o de string
		syscall # Imprime a string
		move $a0, $t0 # Valor de i para impress�o
		li $v0, 1 # C�digo de impress�o de inteiro
		syscall # Imprime i
		la $a0, Ent2 # Carrega o endere�o da string
		li $v0, 4 # C�digo de impress�o de string
		syscall # Imprime a string
		move $a0, $t1 # Valor de j para impress�o
		li $v0, 1 # C�digo de impress�o de inteiro
		syscall # Imprime j
		la $a0, Ent3 # Carrega o endere�o da string
		li $v0, 4 # C�digo de impress�o de string
		syscall # Imprime a string
		li $v0, 5 # C�digo de leitura de inteiro
		syscall # Leitura do valor (retorna em $v0)
		move $t2, $v0 # aux = valor lido
		jal indice # Calcula o endere�o de mat[i][j]
		sw $t2, ($v0) # mat[i][j] = aux
		addi $t1, $t1, 1 # j++
		blt $t1, $a2, l # if(j < ncol) goto l
		li $t1, 0 # j = 0
		addi $t0, $t0, 1 # i++
		blt $t0, $a1, l # if(i < nlin) goto l
		li $t0, 0 # i = 0
		lw $ra, ($sp) # Recupera o retorno para a main
		addi $sp, $sp, 4 # Libera o espa�o na pilha
		move $v0, $a3 # Endere�o base da matriz para retorno
		jr $ra # Retorna para a main

	escrita:
		subi $sp, $sp, 4 # Espa�o para 1 item na pilha
		sw $ra, ($sp) # Salva o retorno para a main
		move $a3, $a0 # aux = endere�o base de mat
		e: 
			jal indice # Calcula o endere�o de mat[i][j]
			lw $a0, ($v0) # Valor em mat[i][j]
			li $v0, 1 # C�digo de impress�o de inteiro
			syscall # Imprime mat[i][j]
			la $a0, 32 # C�digo ASCII para espa�o
			li $v0, 11 # C�digo de impress�o de caractere
			syscall # Imprime o espa�o
			addi $t1, $t1, 1 # j++
			blt $t1, $a2, e # if(j < ncol) goto e
		la $a0, 10 # C�digo ASCII para newline ('\n')
		syscall # Pula a linha
		li $t1, 0 # j = 0
		addi $t0, $t0, 1 # i++
		blt $t0, $a1, e # if(i < nlin) goto e
		li $t0, 0 # i = 0
		lw $ra, ($sp) # Recupera o retorno para a main
		addi $sp, $sp, 4 # Libera o espa�o na pilha
		move $v0, $a3 # Endere�o base da matriz para retorno
		jr $ra # Retorna para a main
