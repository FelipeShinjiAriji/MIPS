.macro readInt # l� um inteiro inserido pelo usu�rio e salva em $v0
	li $v0, 5
	syscall
.end_macro

.macro endProgram # encerra o programa
	li $v0, 10
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

.macro printInt # imprime o inteiro do registrador $a0
	li $v0, 1
	syscall
.end_macro

.data

	X: .space 60

.text

	Main:
		li $a2, 15 # insere 15 no resgistrador de parametro $a2	
		la $a1, X # Carrega o endere�o do primeiro elemento do vetor a ser preenchido no registrador de parametro $a1 
		jal lerInteirosPositivos

		printString("O subconjunto de n�meros primos desse vetor �: ")
		newline
		jal criaSubvetorDePrimos
		la $a1, ($v1) 
		jal printVetorInt
	endProgram

	lerInteirosPositivos: # Recebe o endere�o de um vetor para preencher em $a1 e l� a quantidade de n�meros inteiros positivos do usu�rio equivalente ao valor recebido em $a2, salvando-os no vetor recebido
		# $t0 -> ponteiro para o pr�ximo espa�o vazio do vetor
		# $t1 -> contador de valores recebidos pelo usu�rio
		li $t1, 0 # Zera o registrador da quantidade de n�meros lidos $t1
		la $t0, ($a1) # Aponta o ponteiro $t0 para o primeiro espa�o livre do vetor
		loopLerInteirosPositivos:
			printString("Insira o pr�ximo n�mero a ser inserido no vetor: ")
			readInt
			addi $t1, $t1, 1 # incrementa a quantidade de n n�meros inteiros positivos lidos em $t1
			sw $v0, ($t0) # Armazena o valor recebido pelo usu�rio no pr�ximo espa�o vazio do vetor
			addi $t0, $t0, 4 # incrementa o ponteiro $t0 para o pr�ximo espa�o vazio do vetor
			blt $t1, $a2,  loopLerInteirosPositivos # Enquanto o n�mero de elementos lidos for menor do que 15 repete o loopLerInteiros
		jr $ra

		
	criaSubvetorDePrimos: # Recebe o endere�o do primeiro elemento do vetor em $a1 e o comprimento dele em $a2 , para retornar o endere�o do primeiro elemento do subvetor de primos em $v1
		.data
			Y: .word -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 # criando o vetor do subconjunto de elementos primos
		.text
			# $t0 -> ponteiro para o elemento atualmente avaliado
			# $t1 -> valor atualmente avaliado
			# $t2 -> valor usado para as compara��es 
			# $t3 -> divisor do verificaComposto
			# $t4 -> limitante de divisor
			# $t5 -> quantidade de elementos analisados
			# $t6 -> ponteiro para o vetor a ser retornado
			la $v1, Y # Carrega o endere�o do primeiro elemento do subvetor de primos no registrador de retorno $v1
			la $t6, ($v1) # Carrega o endere�o do primeiro elemento do vetor a ser retornado em $t6
			li $t5, 0 # Zera o registrador da quantidade de elementos analisados $t5
			la $t0, ($a1) # Carrega o endere�o do primeiro elemento do vetor analisado em $t0
			verificaMenor2:
				lw $t1, ($t0) # Carrega o valor do elemento analisado atualmente
				subi $t2, $t1, 2
				blt $t2, $zero,  isNotPrimeNumber
			verifica2e3:
				subi $t2, $t1,  4
				blt $t2, $zero, isPrimeNumber
			verificaPar:
				div $t2, $t1, 2
				mfhi $t2
				beq $t2, $zero, isNotPrimeNumber 
			verificaComposto:
				li $t3, 3 # Carrega o divisor com 3
				div $t4, $t1, 2 # Carrega $t4 com a metade do n�mero que � seu limitante de divisor
				loopVerificaComposto: 
					div $t1, $t3 # divide o n�mero avaliado pelo divisor
					mfhi $t2 # Carrega o resto da divis�o em $t2
					beq $t2, $zero, isNotPrimeNumber # Se o resto da divis�o dp n�mero avaliado pelo divisor for 0 o n�mero n�o � primo
					addi $t3, $t3,  2 # Incrementa o divisor para o pr�ximo divisor �mpar
					blt $t3, $t4, loopVerificaComposto # Enquanto o divisor for menor que o limitante dele repete o loop loopVerificaComposto
					# Se depois de todos os testes, o n�mero n�o possuir nenhum divisor al�m dele mesmo e 1 ele � primo 
			isPrimeNumber:
				sw $t1, ($t6) # Armazena o valor primo no pr�ximo espa�o vazio do vetor de retorno
				addi $t6, $t6, 4 # Incrementa o ponteiro para o pr�ximo elemento do vetor de retorno
				isNotPrimeNumber:
					addi $t0, $t0, 4 # Incrementa o ponteiro para o pr�ximo elemento do vetor
					addi $t5, $t5, 1 # Incrementa o contador de elementos analisados 
					ble $t5, $a2, verificaMenor2 # Enquanto a quantidade de elementos analisados for menor ou igual a quantidade de n�meros do vetor repete o volta para verificaMenor2
				
			jr $ra
				
	printVetorInt: #  Recebe o endere�o do primeiro elemento do vetor em $a1 e imprime todos os n�meros at� o primeiro n�mero negativo
		# $t0 -> Ponteiro para o elemento atualmente avaliado
		# $a0 -> Valor a ser impresso
		la $t0, ($a1) # Carrega em $t0 o endere�o do primeiro elemento do vetor 
		loopPrintVetorInt:
			lw $a0, ($t0) # Carrega em $a1 o valor a ser impresso
			blt  $a0, $zero, encerraPrintVetorInt # Se o valor no vetor for -1 encerra a fun��o
			printInt
			newline
			addi $t0, $t0, 4 # Incrementa o ponteiro para o pr�ximo elemento do vetor
			j loopPrintVetorInt
		encerraPrintVetorInt:
		jr $ra
		 
