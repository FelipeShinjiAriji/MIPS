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

.macro readInt # lê um inteiro inserido pelo usuário e salva em $v0
	li $v0, 5
	syscall
.end_macro

.data

	vet: .space 128

.text

	Main:
	
		printString("Insira o número natural maior que 10 para ser analisado: ")
		readInt
		
		la $a1, ($v0)
		jal calculaQuantidadeDeDigitos

		la $a2, ($v1)
		la $a3, vet
		jal intParaVetorDeDigitos
			
		jal verificaPalindromo
		beqz $v1, NPalindromo
			printString("O número analisado é palíndromo.")
			j final
		NPalindromo:
			printString("O número analisado não é palíndromo.")
		final: 
		
		endProgram
	
		
		calculaQuantidadeDeDigitos: # Recebe o número a ser analisado em $a1 e retorna a quantidade de dígitos dele em $v1
			# $t0 -> divisor de base 10
			# $t1 -> parte inteira do resultado da divisão
			la $v1, ($zero) # Inicia com 0 o contador da quantidade de dígitos
			li $t0, 1 # Inicia o divisor com 10^0
			loopCalculaQuantidadeDeDigitos:
				div $t1, $a1, $t0 # Divide o número analisado pelo divisor e armazena no registrador $t1 a parte inteira do resultado da divisão
				beqz  $t1, fimLoopCalculaQuantidadeDeDigitos # Se o resultado for 0 significa que a operação deve ser encerrada e que a quantidade de dígitos é o atual valor de $v1
				addi $v1, $v1, 1 # Incrementa o valor do contador de quantidade de dígitos
				mulo $t0, $t0, 10 # Multiplica o valor do divisor por 10, para transformá-lo no próximo número de base 10
				j loopCalculaQuantidadeDeDigitos # Enquanto o resultado da divisão 3 linhas acima não for 0 repete o loopCalculaQuantidadeDeDigitos
			fimLoopCalculaQuantidadeDeDigitos:
			jr $ra
			
		verificaPalindromo: # Recebe o endereço do primeiro elemento do vetor a ser analisado em $a3 e a sua quantidade de dígitos em $a2 e retorna em $v1 1 se ele for palíndromo e 0 se não for
			# $t0 -> valor do dígito a ser comparado, que está  mais a esquerda
			# $t1 -> valor do dígito a ser comparado, que está mais a direita
			# $t2 -> contador de comparações
			# $t3 -> quantidade de comparações a serem realizadas
			# $t4 -> ponteiro para o lado esquerdo do vetor de entrada
			# $t5 -> ponteiro para o lado direito do vetor de entrada
			la $t2, ($zero) # Inicia o contador de comparações $t2 com 0
			div $t3, $a2, 2 # Divide a quantidade de dígitos do número analisado por 2 e salva a parte inteira do resultado em $t3 como a quantidade de comparações a serem realizadas
			la $t4, ($a3) # Carrega o endereço do primeiro elemento do vetor de entrada no ponteiro $t4
			subi $t5, $a2, 1 # Carrega em $t5 a quantidade de dígitos do vetor menos 1
			mulo $t5, $t5, 4 # Carrega em $t5 o valor da operação anterior multiplicado por quatro
			add $t5, $t5, $a3 # Soma o endereço do primeiro elemento do vetor ao resultado da multiplicação anterior para criar um ponteiro para o último elemento do vetor
			loopVerificaPalindromo:
				lw $t0, ($t4) # Carrega o valor do elemento apontado pelo ponteiro $t4 em $t0
				lw $t1, ($t5) # Carrega o valor do elemento apontado pelo ponteiro $t5 em $t1
				bne $t0, $t1, digitosDiferentesVerificaPalindromo # Se os dígitos comparados forem diferentes pula para encerra a função pulando para o label digitosDiferentesVerificaPalindromo
				addi $t2, $t2, 1 # Incrementa o contador de comparações realizadas em 1
				addi $t4, $t4, 4 # Incrementa o ponteiro $t4 para o próximo elemento mais a esquerda do vetor
				subi $t5, $t5, 4 # Decrementa o ponteiro $t5 para o elemento anterior
				ble $t2, $t3, loopVerificaPalindromo # Enquanto a quantidade de comparações realizadas for menor ou igual que a quantodade de comparações que devem ser realizadas repete o loopVerificaPalindromo
			li $v1, 1 #  Se todas as comparações foram feitas entre dígitos iguais registra 1 no registrador de saída $v1, para marcar que o número é palíndromo
			j digitosIguaisVerificaPalindromo # Pula o bloco digitosDiferentesVerificaPalindromo, indo para o label digitosIguaisVerificaPalindromo
			digitosDiferentesVerificaPalindromo:
				la $v1, ($zero) # Registra 0 no registrador de saída $v1, para marcar que o número não é palíndromo
			digitosIguaisVerificaPalindromo:
			jr $ra
			
		intParaVetorDeDigitos: # Recebe em $a1 um número inteiro e em $a2 a quantidade de digitos dele e transforma em um vetor de digitos, salvo a partir endereço passado em $a3 começando pelo dígito menos significativo
			# $t0 -> parte do número que ainda precisa ser passada para o vetor
			# $t1-> valor do dígito que será salvo
			# $t2  -> contador de dígitos salvos no vetor
			# $t3 -> ponteiro para o vetor onde serão salvos os dígitos do número
			# $t4 -> constante 10
			la $t0, ($a1) # Carrega em $t0 o número passado como parâmetro
			la $t2, ($zero) # Inicia o contador de digitos salvos com 0
			la $t3, ($a3) # Carrega no ponteiro o com o endereço do primeiro elemento livre do vetor
			li $t4, 10 # Carrega $t4 com 10
			loopIntParaVetorDeDigitos:
				div $t0, $t4 # Divide a parte do número a qual ainda não foi passada para o vetor por 10
				mfhi $t1 # Salva o resto da divisão acima, o qual será um digito, no registrador $t1, para armazenar no vetor
				mflo $t0 # Salva o resultado da divisão acima em $t0 como a parte que ainda precisa passar pelo processo para ser armazenada no vetor
				sw $t1, ($t3) # Armazena o dígito armazenado em $t1 no endereço armazenado em $t3 
				addi $t2, $t2, 1 # Incrementa o contador de dígitos salvos em 1
				addi $t3, $t3, 4 # Incrementa o ponteiro para o próximo elemento livre do vetor
				blt $t2, $a2, loopIntParaVetorDeDigitos # Enquanto o contador de digitos passados para o vetor for menor que a quantidade de digitos do número de entrada repete o loopIntParaVetorDeDigitos
			jr $ra

			
