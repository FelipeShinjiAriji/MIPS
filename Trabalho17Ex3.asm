.macro endProgram # encerra o programa
	li $v0, 10
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
		
		printString("Preencha a matrix: ")
		newline
		
		la $a0, matrixEntrada # Endereço base de Mat
		jal leitura # leitura(mat, nlin, ncol)
		move $a0, $v0 # Endereço da matriz lida
		jal escrita # escrita(mat, nlin, ncol)
		
		la $a1, matrixEntrada
		jal verificaQuadradoMagico
		
		beqz $v1, quadradoMagicoVerdadeiro
			printString("A matriz inserida não é um quadrado mágico.")
			endProgram
		quadradoMagicoVerdadeiro:
			printString("A matriz inserida é um quadrado mágico.")
			endProgram

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
		
	verificaQuadradoMagico: # Recebe em $a2 a ordem da Matriz quadrada inserida e em $a1 o endereço do primeiro elemento dela e retorna em $v1 0 caso a matriz seja um quadrado mágico e 1 caso não seja
		# $t0 -> ponteiro para a matriz quadrada de entrada
		# $t1 -> registrador do valor do elemento atualmente apontado pelo ponteiro $t0
		# $t2 -> contador da quantidade elementos da linha ou da coluna somados
		# $t3 -> registrador da soma da diagonal principal
		# $t4 -> registrador da soma de elementos de uma linha, de uma coluna ou da diagonal secundária
		# $t5 -> registrador da quantidade de bytes necessários serem pulados para passar de um elemento da diagonal principal para outro
		# $t6 -> registrador da quantidade de bytes necessários serem pulados para passar de um elemento da coluna para outro
		# $t7 ->registrador da quantidade de bytes necessários serem pulados para deslocar o ponteiro para a coluna a ser avaliada	
		# $t8 -> contador da quantidade de linhas ou colunas testados
		# $t9 -> registrador do tamanho da matriz em bytes
			la $t0, ($a1) # Carrega o endereço do primeiro elemento da matriz de entrada no ponteiro $t0
			la $t2, ($zero) # Inicia o contador da quantidade elementos da diagonal principal somados com 0
			la $t3, ($zero) # Inicia o registrador da soma da diagonal principal com 0
			mulo $t5, $a2, 4 # Carrega em $t5 o valor da multiplicação ordem pelo número de bytes ocupados por 1 elemento, ou seja a distância para pular uma linha inteira para o próximo elemento da coluna
			la $t6, ($t5) # Copia em $t6 o valor da multiplicação ordem pelo número de bytes ocupados por 1 elemento, ou seja a distância para pular uma linha inteira para o próximo elemento da coluna
			addi $t5, $t5, 4 # Soma 4 ao valor de $t5 para permitir pular uma linha e uma coluna
			loopDiagonalPrincipalVerificaQuadradoMagico:
				lw $t1, ($t0) # Carrega em $t1 o valor do elemento apontado pelo ponteiro $t1
				add $t3, $t3, $t1 # Soma ao valor total da soma da diagonal principal $t3, o valor carregado em $t1
				add $t0, $t0, $t5 # Incrementa o ponteiro para o próximo elemento da diagonal principal
				addi $t2, $t2, 1 # Incrementa o contador de elementos da diagonal principal somados $t2 em 1
				blt $t2, $a2, loopDiagonalPrincipalVerificaQuadradoMagico # Enquanto a quantidade de elementos somados for menor que a ordem da matriz repete o loopDiagonalPrincipalVerificaQuadradoMagico
			la $t0, ($a1) # Reseta o ponteiro $t0 para o primeiro elemento da matriz de entrada
			la $t8, ($zero) # Inicia o contador da quantidade de linhas testados $t8 com 0
			loopLinhasVerificaQuadradoMagico:
				la $t2, ($zero) # Reseta o contador $t2 para 0
				la $t4, ($zero) # Reseta o somatório da linha $t4 para 0
				loopSomaLinhaVerificaQuadradoMagico:
					lw $t1, ($t0) # Carrega em $t1 o valor do elemento apontado pelo ponteiro $t1
					add $t4, $t4, $t1 # Soma ao valor total da soma da linha $t4, o valor carregado em $t1
					addi $t0, $t0, 4 # Incrementa o ponteiro para o próximo elemento da linha
					addi $t2, $t2, 1 # Incrementa o contador de elementos da linha somados $t2 em 1
					blt $t2, $a2, loopSomaLinhaVerificaQuadradoMagico # Enquanto a quantidade de elementos somados for menor que a ordem da matriz repete o loopSomaLinhaVerificaQuadradoMagico
				bne $t4, $t3, falsoVerificaQuadradoMagico # Se a soma dos elementos de uma das linhas for diferente da soma dos elementos da diagonal principal a matriz de entrada não é quadrado mágico
				addi $t8, $t8, 1 # Incrementa o contador da quantidade de linhas testadas $t8 em 1
				blt $t8, $a2, loopLinhasVerificaQuadradoMagico # Enquanto a quantidade de linhas testadas $t8 for menor que a ordem da matriz de entrada repete o loopLinhasVerificaQuadradoMagico
			la $t8, ($zero) # Inicia o contador da quantidade de colunas testados $t8 com 0
			la $t7, ($zero) # Carrega a quantidade de bytes necessários serem pulados para deslocar o ponteiro para a coluna a ser avaliada $t7 com 0
			loopColunasVerificaQuadradoMagico:
				la $t0, ($a1) # Reseta o ponteiro $t0 para o primeiro elemento da matriz de entrada
				add $t0, $t0, $t7 # Soma $t7 ao ponteiro para fazê-lo apontar para a próxima coluna a ser avaliada
				la $t2, ($zero) # Inicia o contador da quantidade elementos da coluna verificados com 0
				la $t4, ($zero) # Inicia o registrador da soma da linha, coluna ou diagonal secundária verificados com 0
				loopSomaColunaVerificaQuadradoMagico:
					lw $t1, ($t0) # Carrega em $t1 o valor do elemento apontado pelo ponteiro $t1
					add $t4, $t4, $t1 # Soma ao valor total da soma da coluna $t4, o valor carregado em $t1
					add $t0, $t0, $t6 # Incrementa o ponteiro para o próximo elemento da coluna
					addi $t2, $t2, 1 # Incrementa o contador de elementos da coluna somados $t2 em 1
					blt $t2, $a2, loopSomaColunaVerificaQuadradoMagico # Enquanto a quantidade de elementos somados for menor que a ordem da matriz repete o loopSomaColunaVerificaQuadradoMagico
				bne $t4, $t3, falsoVerificaQuadradoMagico # Se a soma dos elementos de uma das colunas for diferente da soma dos elementos da diagonal principal a matriz de entrada não é quadrado mágico
				addi $t8, $t8, 1 # Incrementa o contador da quantidade de colunas testadas $t8 em 1
				addi $t7, $t7, 4 # Incrementa $t7 em 4 para apontar para a próxima coluna
				blt $t8, $a2, loopColunasVerificaQuadradoMagico # Enquanto a quantidade de colunas testadas $t8 for menor que a ordem da matriz de entrada repete o loopColunasVerificaQuadradoMagico
			la $t2, ($zero) # Inicia o contador da quantidade elementos da coluna verificados com 0
			la $t4, ($zero) # Inicia o registrador da soma da linha, coluna ou diagonal secundária verificados com 0
			la $t0, ($a1) # Reseta o ponteiro $t0 para o primeiro elemento da matriz de entrada
			mulo $t9, $t6, $a2 # Carrega $t9 com a multiplicação do espaço de memória ocupado por 1 linha multiplicado pela ordem da matriz
			subi $t9, $t9, 4 # Subtrai 4, em bytes o equivalente a um espaço de inteiro de $t9
			add $t0, $t0, $t9 # Soma o ponteiro com $t9, que contem o tamanho da matriz assim fazendo com que o ponteiro aponte para o final da matriz
			loopSomaDiagonalSecundariaVerificaQuadradoMagico:
				lw $t1, ($t0) # Carrega em $t1 o valor do elemento apontado pelo ponteiro $t1
				add $t4, $t4, $t1 # Soma ao valor total da soma da diagonal secundária $t4, o valor carregado em $t1
				sub $t0, $t0, $t5 # Decrementa o ponteiro $t0 para o elemento anterior da diagonal principal
				addi $t2, $t2, 1 # Incrementa o contador de elementos da diagonal secundária somados $t2 em 1
				blt $t2, $a2, loopSomaDiagonalSecundariaVerificaQuadradoMagico # Enquanto a quantidade de elementos somados for menor que a ordem da matriz repete o loopSomaDiagonalSecundariaVerificaQuadradoMagico
			bne $t4, $t3, falsoVerificaQuadradoMagico # Se a soma dos elementos da diagonal secundária for diferente da soma dos elementos da diagonal principal a matriz de entrada não é quadrado mágico
		la $v0, ($zero) # Se passou por todas as verificações e não quebrou nenhuma das regras do quadrado mágico então a matriz de entrada é um quadrado mágico então deve se carregar 0 no registrador de retorno $v1
		jr $ra
		falsoVerificaQuadradoMagico:
			li $v1, 1 # Se alguma das regras para ser quadrado mágico for quebrada a matriz de entrada não é quadrado mágico, então deve ser carregado 1 em $v0 
			jr $ra
		
		
