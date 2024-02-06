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

	matrixEntrada: .space 256
	Ent1: .asciiz " Insira o valor de Mat["
	Ent2: .asciiz "]["
	Ent3: .asciiz "]: "

.text
	Main:
		
		printString("Insira a ordem da matrix quadrada: ")
		readInt
		la $a1, ($v0)
		la $a2, ($v0)
		
		printString("Preencha a matrix quadrada: ")
		newline
		
		la $a0, matrixEntrada # Endere�o base de Mat
		jal leitura # leitura(mat, nlin, ncol)
		move $a0, $v0 # Endere�o da matriz lida
		jal escrita # escrita(mat, nlin, ncol)
		
		la $a2,  matrixEntrada
		jal verificaMatrixPermutacao
		
		newline
		
		beqz $v1, matrixPermutacaoVerdadeiro
			printString("A matrix inserida n�o � de permuta��o.")
			endProgram
		matrixPermutacaoVerdadeiro:
			printString("A matrix inserida � de permuta��o.")
			endProgram

	verificaMatrixPermutacao: # Recebe em $a2 o endere�o do primeiro elemento de uma matriz quadrada e sua ordem em $a1, retorna em $v1 0 caso essa matriz seja de permuta��o e 1 caso n�o seja
		# $t0 -> ponteiro para a matriz de entrada
		# $t1 -> valor do elemento apontado pelo ponteiro $t0
		# $t2 -> contador de colunas percorridas na matriz
		# $t3 -> contador de linhas percorridas na matriz
		# $t4 -> contador da quantidade de 0 da linha ou da coluna havaliada
		# $t5 -> registrador da quantidade de bytes necess�rios para deslocar o ponteiro para o pr�ximo elemento da coluna da matriz
		# $t6 -> registrador da quantidade de bytes para deslocar o ponteiro para a coluna a ser avaliada
		la $t0, ($a2) # Carrega o endere�o do primeiro elemento da matriz em $t0
		la $t3, ($zero) # Incia o contador de linhas percorridas na matriz $t3 com 0
		loopLinhaVerificaMatrixPermutacao:
			la $t2, ($zero) # Incia o contador de colunas percorridas na matriz $t2 com 0
			la $t4, ($zero) # Inicia o contador da quantidade de 0 da linha havaliada com 0
			loopLinhaInternoVerificaMatrixPermutacao:
				lw $t1, ($t0) # Carrega o em $t1 o valor do elemento apontado pelo ponteiro $t0
				bltz $t1, falsoVerificaMatrixPermutacao # Se houver um elemento menor que 0 na matriz de entrada ela n�o � de permuta��o, ent�o vai para falsoVerificaMatrixPermutacao
				bgt $t1, 1, falsoVerificaMatrixPermutacao # Se houver um elemento maior que 1 na matriz de entrada ela n�o � de permuta��o, ent�o vai para falsoVerificaMatrixPermutacao
				beqz $t1, zeroEncontradoLinhaVerificaMatrixPermutacao # Se $t1 for igual a zero pula a linha abaixo at� p label zeroEncontradoLinhaVerificaMatrixPermutacao
					addi $t4, $t4, 1 # Incrementa o contador da quantidade de 0 da linha havaliada $t4 em 1
				zeroEncontradoLinhaVerificaMatrixPermutacao:
				addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o pr�ximo elemento da matriz de entrada
				addi $t2, $t2, 1 # Incrementa o contador da quantidade de colunas percorridas na matriz $t2 em 1
				blt $t2, $a1, loopLinhaInternoVerificaMatrixPermutacao # Enquanto a quantidade de colunas percorridas na matriz for menor que a ordem dela repete o loopLinhaInternoVerificaMatrixPermutacao
			bne $t4, 1, falsoVerificaMatrixPermutacao # Se a quantidade de n�meros 1 na mesma linha for diferente de 1 a matriz n�o � de permuta��o, ent�o vai para a label falsoVerificaMatrixPermutacao
			addi $t3, $t3, 1 # Incrementa o contador de linhas percorridas na matriz $t3 em 1
			blt $t3, $a1, loopLinhaVerificaMatrixPermutacao # Enquanto a quantidade de linhas percorridas na matriz for menor que a ordem dela repete o loopLinhaVerificaMatrixPermutacao
		mulo $t5, $a1, 4 # Carrega em $t5 o valor da multiplica��o ordem pelo n�mero de bytes ocupados por 1 elemento
		la $t0, ($a2) # Carrega o endere�o do primeiro elemento da matriz em $t0
		la $t2, ($zero) # Incia o contador de colunas percorridas na matriz $t3 com 0
		loopColunaVerificaMatrixPermutacao:
			la $t3, ($zero) # Incia o contador de linhas percorridas na matriz $t3 com 0
			la $t4, ($zero) # Inicia o contador da quantidade de 0 da coluna havaliada com 0
			la $t0, ($a2) # Carrega o endere�o do primeiro elemento da matriz em $t0
			mulo $t6, $t2, 4 # Carrega $t6 com a quantidade de bytes para deslocar o ponteiro para a coluna a ser avaliada, ou seja 4 * quantidade de colunas j� percorridas
			add $t0, $t0, $t6 # Soma no ponteiro $t0 a quantidade necess�ria para deslocar o ponteiro para a coluna a ser analisada no loop atual
			loopColunaInternoVerificaMatrixPermutacao:
				lw $t1, ($t0) # Carrega o em $t1 o valor do elemento apontado pelo ponteiro $t0
				bltz $t1, falsoVerificaMatrixPermutacao # Se houver um elemento menor que 0 na matriz de entrada ela n�o � de permuta��o, ent�o vai para falsoVerificaMatrixPermutacao
				bgt $t1, 1, falsoVerificaMatrixPermutacao # Se houver um elemento maior que 1 na matriz de entrada ela n�o � de permuta��o, ent�o vai para falsoVerificaMatrixPermutacao
				beqz $t1, zeroEncontradoColunaVerificaMatrixPermutacao # Se $t1 for igual a zero pula a linha abaixo at� p label zeroEncontradoColunaVerificaMatrixPermutacao
					addi $t4, $t4, 1 # Incrementa o contador da quantidade de 0 da coluna havaliada $t4 em 1
				zeroEncontradoColunaVerificaMatrixPermutacao:
				add $t0, $t0, $t5 # Incrementa o ponteiro $t0 para o pr�ximo elemento da coluna atual da matriz de entrada
				addi $t3, $t3, 1 # Incrementa o contador da quantidade de linhas percorridas na matriz $t3 em 1
				blt $t3, $a1, loopColunaInternoVerificaMatrixPermutacao # Enquanto a quantidade de linhas percorridas na matriz for menor que a ordem dela repete o loopColunaInternoVerificaMatrixPermutacao
			bne $t4, 1, falsoVerificaMatrixPermutacao # Se a quantidade de n�meros 1 na mesma coluna for diferente de 1 a matriz n�o � de permuta��o, ent�o vai para a label falsoVerificaMatrixPermutacao
			addi $t2, $t2, 1 # Incrementa o contador de colunas percorridas na matriz $t2 em 1
			blt $t2, $a1, loopColunaVerificaMatrixPermutacao # Enquanto a quantidade de colunas percorridas na matriz for menor que a ordem dela repete o loopColunaVerificaMatrixPermutacao	
		la $v0, ($zero) # Se passou por todas as verifica��es e n�o quebrou nenhuma das regras da matriz de permuta��o ent�o a matriz de entrada � de permuta��o ent�o deve se carregar 0 no registrador de retorno $v1
		jr $ra
		falsoVerificaMatrixPermutacao:
			li $v1, 1 # Se alguma das regras para ser matriz de permuta��o for quebrada a matriz de entrada n�o � de permuta��o, ent�o deve ser carregado 1 em $v0 
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
