.macro endProgram # encerra o programa
	li $v0, 10
	syscall
.end_macro

.macro newline # quebra linha
	li $a0, 10 # Código ASCII para ("\n")	
	li $v0, 11 # Código de impressão de caractere
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

.macro readInt # lê um inteiro inserido pelo usuário e salva em $v0
	li $v0, 5
	syscall
.end_macro

.macro printInt # imprime o inteiro do registrador $a0
	li $v0, 1
	syscall
.end_macro

.macro printInt (%int) # salva em $a0 o valor fornecido no parâmetro como inteiro e imprime-o
	la $a0, (%int)
	li $v0, 1 # código de impressão de inteiro
	syscall
.end_macro

.data

	matrixEntrada: .space 256
	Ent1: .asciiz " Insira o valor de Mat["
	Ent2: .asciiz "]["
	Ent3: .asciiz "]: "

.text
	
	Main:
		
		printString("Insira a quantidade de linhas da matrix: ")
		readInt
		la $a1, ($v0)
		
		printString("Insira a quantidade de colunas da matrix: ")
		readInt
		la $a2, ($v0)
		
		printString("Preencha a matrix: ")
		newline
		
		la $a0, matrixEntrada # Endereço base de Mat
		jal leitura # leitura(mat, nlin, ncol)
		move $a0, $v0 # Endereço da matriz lida
		jal escrita # escrita(mat, nlin, ncol)
		
		newline
		printString("Linhas nulas da matrix = ")
		la $a3, matrixEntrada
		jal contaLinhasNulasMatrix
		printInt($v1)
		
		newline
		printString("Colunas nulas da matrix = ")
		jal contaColunasNulasMatrix
		printInt($v1)
		
		endProgram
		
	contaLinhasNulasMatrix: # Recebe em $a3 o endereço do primeiro elemento de uma matriz, em $a1 a quantidade de linhas dessa matriz e em $a2 a de colunas e retorna em $v1 a quantidade de linhas nulas
		# $t0 -> ponteiro para a matriz de entrada
		# $t1 -> contador de elementos da linha percorridos
		# $t2 -> contador de linhas percorridas
		# $t3 -> registrador temporário do valor do elemento apontado por $t0
		# $t4 -> contador da quantidade de números diferentes de 0 da linha
		la $v1, ($zero) # Inicia o registrador de retorno da quantidade de linhas nulas com 0
		la $t0, ($a3) # Carrega o ponteiro com o endereço do primeiro elemento da matriz de entrada
		la $t2, ($zero) # Inicia o contador de linhas percorridas com 0
		loopColunaContaLinhasNulasMatrix:
			la $t1, ($zero) # Inicia o contador de elementos da linha percorridos com 0
			la $t4, ($zero) # Inicia o contador da quantidade de números diferentes de 0 da linha com 0
			loopLinhaContaLinhasNulasMatrix:
				lw $t3, ($t0) # Carrega em $t3 o valor do elemento apontado por $t0
				addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o próximo elemento da matriz de entrada
				addi $t1, $t1, 1 # Incrementa o contador $t1 de elementos da linha percorridos em 1
				beqz $t3, zeroEncontradoContaLinhasNulasMatrix # Se o valor de $t3 for igual a zero pula o bloco abaixo até o label zeroEncontradoContaLinhasNulasMatrix
					addi $t4, $t4, 1 # Incrementa em 1 o contador da quantidade de números diferentes de 0 da linha
				zeroEncontradoContaLinhasNulasMatrix:
				blt $t1, $a2, loopLinhaContaLinhasNulasMatrix # Enquanto o contador de elementos da linha percorridos $t1 for menor do que a quantidade de colunas da matriz de entrada repete o loopLinhaContaLinhasNulasMatrix
			bgtz $t4, linhaNulaFalsoContaLinhasNulasMatrix # Se a quantidade de elementos diferentes de 0 for maior do que 0 a linha não é nula portanto pula a linha abaixo para a label linhaNulaFalsoContaLinhasNulasMatrix
				addi $v1, $v1, 1 # Se não a linha é nula, portanto incrementa o registrador de retorno da quantidade de linhas nulas em 1
			linhaNulaFalsoContaLinhasNulasMatrix:
			addi $t2, $t2, 1 # Incrementa em 1 o contador de linhas percorridas
			blt $t2, $a1, loopColunaContaLinhasNulasMatrix # Enquanto o contador de linhas percorridas $t2 for menor do que a quantidade de linhas da matriz de entrada repete o loopColunaContaLinhasNulasMatrix
		jr $ra

	contaColunasNulasMatrix:# Recebe em $a3 o endereço do primeiro elemento de uma matriz, em $a1 a quantidade de linhas dessa matriz e em $a2 a de colunas e retorna em $v1 a quantidade de colunas nulas
		# $t0 -> ponteiro para a matriz de entrada
		# $t1 -> contador de elementos da coluna percorridos
		# $t2 -> contador de colunas percorridas
		# $t3 -> registrador temporário do valor do elemento apontado por $t0
		# $t4 -> contador da quantidade de números diferentes de 0 da coluna
		# $t5 -> registrador da quantidade de bytes necessários para passar para o próximo elemento da coluna
		# $t6 -> registrador da quantidade de bytes necessários para deslocar o ponteiro uma coluna da matriz de entrada
		# $t7 -> registrador da quantidade de bytes necessários para realocar o ponteiro para a próxima coluna
		la $v1, ($zero) # Inicia o registrador de retorno da quantidade de colunas nulas com 0
		la $t2, ($zero) # Inicia o contador de colunas percorridas com 0
		mulo $t5, $a2, 4 # Carrega $t5 com a quantidade de memória ocupada por uma linha da matriz, no caso a quantidade de colunas * 4
		loopLinhaContaColunasNulasMatrix:
			la $t0, ($a3) # Carrega o ponteiro com o endereço do primeiro elemento da matriz de entrada
			la $t1, ($zero) # Inicia o contador de elementos da coluna percorridos com 0
			la $t4, ($zero) # Inicia o contador da quantidade de números diferentes de 0 da coluna com 0
			mulo $t7, $t2, 4 # Carrega $t7 com a quantidade de bytes para deslocar o ponteiro para a coluna a ser avaliada, ou seja 4 * quantidade de colunas já percorridas
			add $t0, $t0, $t7 # Soma no ponteiro $t0 a quantidade necessária para deslocar o ponteiro para a coluna a ser analisada no loop atual
			loopColunaContaColunasNulasMatrix:
				lw $t3, ($t0) # Carrega em $t3 o valor do elemento apontado por $t0
				add $t0, $t0, $t5 # Incrementa o ponteiro $t0 para a próxima coluna da matriz de entrada
				addi $t1, $t1, 1 # Incrementa o contador $t1 de elementos da coluna percorridos em 1
				beqz $t3, zeroEncontradoContaColunasNulasMatrix # Se o valor de $t3 for igual a zero pula o bloco abaixo até o label zeroEncontradoContaColunasNulasMatrix
					addi $t4, $t4, 1 # Incrementa em 1 o contador da quantidade de números diferentes de 0 da coluna
				zeroEncontradoContaColunasNulasMatrix:
				blt $t1, $a1, loopColunaContaColunasNulasMatrix # Enquanto o contador de elementos da coluna percorridos $t1 for menor do que a quantidade de linhas da matriz de entrada repete o loopColunaContaColunasNulasMatrix
			bgtz $t4, linhaNulaFalsoContaColunasNulasMatrix # Se a quantidade de elementos diferentes de 0 for maior do que 0 a coluna não é nula portanto pula a linha abaixo para a label linhaNulaFalsoContaColunasNulasMatrix
				addi $v1, $v1, 1 # Se não a coluna é nula, portanto incrementa o registrador de retorno da quantidade de colunas nulas em 1
			linhaNulaFalsoContaColunasNulasMatrix:
			addi $t2, $t2, 1 # Incrementa em 1 o contador de colunas percorridas
			blt $t2, $a2, loopLinhaContaColunasNulasMatrix # Enquanto o contador de colunas percorridas $t2 for menor do que a quantidade de colunas da matriz de entrada repete o loopLinhaContaColunasNulasMatrix

		jr $ra
	
	indice:
		mul $v0, $t0, $a2 # i * ncol
		add $v0, $v0, $t1 # (i * ncol) + j
		sll $v0, $v0, 2 # [(i * ncol) + j] * 4 (inteiro)
		add $v0, $v0, $a3 # Soma o endereço base de mat
		jr $ra # Retorna para o caller
	
	leitura:
		subi $sp, $sp, 4 # Espaço para 1 item na pilha
		sw $ra, ($sp) # Salva o retorno para a main
		move $a3, $a0 # aux = endereço base de mat
		l: la $a0, Ent1 # Carrega o endereço da string
		li $v0, 4 # Código de impressão de string
		syscall # Imprime a string
		move $a0, $t0 # Valor de i para impressão
		li $v0, 1 # Código de impressão de inteiro
		syscall # Imprime i
		la $a0, Ent2 # Carrega o endereço da string
		li $v0, 4 # Código de impressão de string
		syscall # Imprime a string
		move $a0, $t1 # Valor de j para impressão
		li $v0, 1 # Código de impressão de inteiro
		syscall # Imprime j
		la $a0, Ent3 # Carrega o endereço da string
		li $v0, 4 # Código de impressão de string
		syscall # Imprime a string
		li $v0, 5 # Código de leitura de inteiro
		syscall # Leitura do valor (retorna em $v0)
		move $t2, $v0 # aux = valor lido
		jal indice # Calcula o endereço de mat[i][j]
		sw $t2, ($v0) # mat[i][j] = aux
		addi $t1, $t1, 1 # j++
		blt $t1, $a2, l # if(j < ncol) goto l
		li $t1, 0 # j = 0
		addi $t0, $t0, 1 # i++
		blt $t0, $a1, l # if(i < nlin) goto l
		li $t0, 0 # i = 0
		lw $ra, ($sp) # Recupera o retorno para a main
		addi $sp, $sp, 4 # Libera o espaço na pilha
		move $v0, $a3 # Endereço base da matriz para retorno
		jr $ra # Retorna para a main

	escrita:
		subi $sp, $sp, 4 # Espaço para 1 item na pilha
		sw $ra, ($sp) # Salva o retorno para a main
		move $a3, $a0 # aux = endereço base de mat
		e: 
			jal indice # Calcula o endereço de mat[i][j]
			lw $a0, ($v0) # Valor em mat[i][j]
			li $v0, 1 # Código de impressão de inteiro
			syscall # Imprime mat[i][j]
			la $a0, 32 # Código ASCII para espaço
			li $v0, 11 # Código de impressão de caractere
			syscall # Imprime o espaço
			addi $t1, $t1, 1 # j++
			blt $t1, $a2, e # if(j < ncol) goto e
		la $a0, 10 # Código ASCII para newline ('\n')
		syscall # Pula a linha
		li $t1, 0 # j = 0
		addi $t0, $t0, 1 # i++
		blt $t0, $a1, e # if(i < nlin) goto e
		li $t0, 0 # i = 0
		lw $ra, ($sp) # Recupera o retorno para a main
		addi $sp, $sp, 4 # Libera o espaço na pilha
		move $v0, $a3 # Endereço base da matriz para retorno
		jr $ra # Retorna para a main
