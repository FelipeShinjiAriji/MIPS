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

.macro readInt # l� um inteiro inserido pelo usu�rio e salva em $v0
	li $v0, 5
	syscall
.end_macro

.data

	vet: .space 128

.text

	Main:
	
		printString("Insira o n�mero natural maior que 10 para ser analisado: ")
		readInt
		
		la $a1, ($v0)
		jal calculaQuantidadeDeDigitos

		la $a2, ($v1)
		la $a3, vet
		jal intParaVetorDeDigitos
			
		jal verificaPalindromo
		beqz $v1, NPalindromo
			printString("O n�mero analisado � pal�ndromo.")
			j final
		NPalindromo:
			printString("O n�mero analisado n�o � pal�ndromo.")
		final: 
		
		endProgram
	
		
		calculaQuantidadeDeDigitos: # Recebe o n�mero a ser analisado em $a1 e retorna a quantidade de d�gitos dele em $v1
			# $t0 -> divisor de base 10
			# $t1 -> parte inteira do resultado da divis�o
			la $v1, ($zero) # Inicia com 0 o contador da quantidade de d�gitos
			li $t0, 1 # Inicia o divisor com 10^0
			loopCalculaQuantidadeDeDigitos:
				div $t1, $a1, $t0 # Divide o n�mero analisado pelo divisor e armazena no registrador $t1 a parte inteira do resultado da divis�o
				beqz  $t1, fimLoopCalculaQuantidadeDeDigitos # Se o resultado for 0 significa que a opera��o deve ser encerrada e que a quantidade de d�gitos � o atual valor de $v1
				addi $v1, $v1, 1 # Incrementa o valor do contador de quantidade de d�gitos
				mulo $t0, $t0, 10 # Multiplica o valor do divisor por 10, para transform�-lo no pr�ximo n�mero de base 10
				j loopCalculaQuantidadeDeDigitos # Enquanto o resultado da divis�o 3 linhas acima n�o for 0 repete o loopCalculaQuantidadeDeDigitos
			fimLoopCalculaQuantidadeDeDigitos:
			jr $ra
			
		verificaPalindromo: # Recebe o endere�o do primeiro elemento do vetor a ser analisado em $a3 e a sua quantidade de d�gitos em $a2 e retorna em $v1 1 se ele for pal�ndromo e 0 se n�o for
			# $t0 -> valor do d�gito a ser comparado, que est�  mais a esquerda
			# $t1 -> valor do d�gito a ser comparado, que est� mais a direita
			# $t2 -> contador de compara��es
			# $t3 -> quantidade de compara��es a serem realizadas
			# $t4 -> ponteiro para o lado esquerdo do vetor de entrada
			# $t5 -> ponteiro para o lado direito do vetor de entrada
			la $t2, ($zero) # Inicia o contador de compara��es $t2 com 0
			div $t3, $a2, 2 # Divide a quantidade de d�gitos do n�mero analisado por 2 e salva a parte inteira do resultado em $t3 como a quantidade de compara��es a serem realizadas
			la $t4, ($a3) # Carrega o endere�o do primeiro elemento do vetor de entrada no ponteiro $t4
			subi $t5, $a2, 1 # Carrega em $t5 a quantidade de d�gitos do vetor menos 1
			mulo $t5, $t5, 4 # Carrega em $t5 o valor da opera��o anterior multiplicado por quatro
			add $t5, $t5, $a3 # Soma o endere�o do primeiro elemento do vetor ao resultado da multiplica��o anterior para criar um ponteiro para o �ltimo elemento do vetor
			loopVerificaPalindromo:
				lw $t0, ($t4) # Carrega o valor do elemento apontado pelo ponteiro $t4 em $t0
				lw $t1, ($t5) # Carrega o valor do elemento apontado pelo ponteiro $t5 em $t1
				bne $t0, $t1, digitosDiferentesVerificaPalindromo # Se os d�gitos comparados forem diferentes pula para encerra a fun��o pulando para o label digitosDiferentesVerificaPalindromo
				addi $t2, $t2, 1 # Incrementa o contador de compara��es realizadas em 1
				addi $t4, $t4, 4 # Incrementa o ponteiro $t4 para o pr�ximo elemento mais a esquerda do vetor
				subi $t5, $t5, 4 # Decrementa o ponteiro $t5 para o elemento anterior
				ble $t2, $t3, loopVerificaPalindromo # Enquanto a quantidade de compara��es realizadas for menor ou igual que a quantodade de compara��es que devem ser realizadas repete o loopVerificaPalindromo
			li $v1, 1 #  Se todas as compara��es foram feitas entre d�gitos iguais registra 1 no registrador de sa�da $v1, para marcar que o n�mero � pal�ndromo
			j digitosIguaisVerificaPalindromo # Pula o bloco digitosDiferentesVerificaPalindromo, indo para o label digitosIguaisVerificaPalindromo
			digitosDiferentesVerificaPalindromo:
				la $v1, ($zero) # Registra 0 no registrador de sa�da $v1, para marcar que o n�mero n�o � pal�ndromo
			digitosIguaisVerificaPalindromo:
			jr $ra
			
		intParaVetorDeDigitos: # Recebe em $a1 um n�mero inteiro e em $a2 a quantidade de digitos dele e transforma em um vetor de digitos, salvo a partir endere�o passado em $a3 come�ando pelo d�gito menos significativo
			# $t0 -> parte do n�mero que ainda precisa ser passada para o vetor
			# $t1-> valor do d�gito que ser� salvo
			# $t2  -> contador de d�gitos salvos no vetor
			# $t3 -> ponteiro para o vetor onde ser�o salvos os d�gitos do n�mero
			# $t4 -> constante 10
			la $t0, ($a1) # Carrega em $t0 o n�mero passado como par�metro
			la $t2, ($zero) # Inicia o contador de digitos salvos com 0
			la $t3, ($a3) # Carrega no ponteiro o com o endere�o do primeiro elemento livre do vetor
			li $t4, 10 # Carrega $t4 com 10
			loopIntParaVetorDeDigitos:
				div $t0, $t4 # Divide a parte do n�mero a qual ainda n�o foi passada para o vetor por 10
				mfhi $t1 # Salva o resto da divis�o acima, o qual ser� um digito, no registrador $t1, para armazenar no vetor
				mflo $t0 # Salva o resultado da divis�o acima em $t0 como a parte que ainda precisa passar pelo processo para ser armazenada no vetor
				sw $t1, ($t3) # Armazena o d�gito armazenado em $t1 no endere�o armazenado em $t3 
				addi $t2, $t2, 1 # Incrementa o contador de d�gitos salvos em 1
				addi $t3, $t3, 4 # Incrementa o ponteiro para o pr�ximo elemento livre do vetor
				blt $t2, $a2, loopIntParaVetorDeDigitos # Enquanto o contador de digitos passados para o vetor for menor que a quantidade de digitos do n�mero de entrada repete o loopIntParaVetorDeDigitos
			jr $ra

			
