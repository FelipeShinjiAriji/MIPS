.data
	vet: .word 1,1,1,1,1,1,1,1,1,1
	
	charNewline: .asciiz "\n"
	
	mensagemMaior: .asciiz  "O maior elemento do vetor �: "
	mensagemMenor: .asciiz  "O menor elemento do vetor �: "
	mensagemQuantidadePares: .asciiz  "A quantidade de n�meros pares do vetor �: "
	mensagemMaiorPar: .asciiz  "O maior elemento par do vetor �: "
	mensagemMenorImpar: .asciiz  "O menor elemento �mpar do vetor �: "
	mensagemSomaImpares: .asciiz  "A soma dos elementos �mpares do vetor �: "
	mensagemProdutoPares: .asciiz  "O produto dos elementos pares do vetor �: "
	
	mensagemExecaoEncontraMaiorPar: .asciiz "N�o existe nenhum par no vetor, portanto o maior par n�o pode ser encontrado."
	mensagemExecaoEncontraMenorImpar: .asciiz "N�o existe nenhum �mpar no vetor, portanto o menor �mpar n�o pode ser encontrado."
	mensagemExecaoCalculaSomaImpares: .asciiz "N�o existe nenhum �mpar no vetor, portanto a soma dos elementos �mpares n�o pode ser calculada."
	mensagemExecaoCalculaProdutoPares: .asciiz "N�o existe nenhum par no vetor, portanto o produto dos elementos pares n�o pode ser calculado."
	
	# $a0 -> par�metros para syscall
	# $a1 -> par�metro vetor de inteiros para os procedimentos de an�lise de vetor
	# $a2 -> par�metro inteiro: comprimento do vetor para os procedimentos de an�lise de vetor
	# $v0 -> chamadas de syscall
	# $v1 -> retorno dos procedimentos
	
	.macro printString  # imprime a string do registrador $a0
		li $v0, 4
		syscall
	.end_macro
		
	.macro printInt # imprime o inteiro do registrador $a0
		li $v0, 1
		syscall
	.end_macro
	
	.macro newline # quebra linha
		lw $a0, charNewline
		li $v0, 11
		syscall
	.end_macro
	
	.macro endProgram # encerra o programa
		li $v0, 10
		syscall
	.end_macro

.text
	Main:
		la $a1, vet # carrega no registrador $a1 o endere�o do primeiro elemento do vetor a ser passado como par�metro para as fun��es
		li $a2, 10 # carrega no registrador $a2 o comprimento do vetor a ser passado como par�metro no $a1
		
		jal encontraMaior # aplica o procedimento encontraMaior e salva o endere�o dessa chamada de fun��o em $ra
		la $a0, mensagemMaior # carrega a mensagem de retorno do procedimento encontraMaior em $a0, para poder imprimi-la
		printString # imprime a mensagem de retorno do procedimento encontraMaior
		la $a0, ($v1) # carrega o valor de retorno do procedimento encontraMaior em $a0, para poder imprimi-lo
		printInt # imprime o resultado do procedimento encontraMaior
		newline
		
		jal encontraMenor # aplica o procedimento encontraMenor e salva o endere�o dessa chamada de fun��o em $ra
		la $a0, mensagemMenor # carrega a mensagem de retorno do procedimento encontraMenor em $a0, para poder imprimi-la
		printString # imprime a mensagem de retorno do procedimento encontraMenor
		la $a0, ($v1) # carrega o valor de retorno do procedimento  encontraMenor em $a0, para poder imprimi-lo
		printInt # imprime o retorno do procedimento encontraMenor
		newline
		
		jal calculaQuantidadePares # aplica o procedimento calculaQuantidadePares e salva o endere�o dessa chamada de fun��o em $ra
		la $a0, mensagemQuantidadePares # carrega a mensagem de retorno do procedimento calculaQuantidadePares em $a0, para poder imprimi-la
		printString # imprime a mensagem de retorno do procedimento calculaQuantidadePares
		la $a0, ($v1) # carrega o valor de retorno do procedimento  calculaQuantidadePares em $a0, para poder imprimi-lo
		printInt # imprime o resultado do procedimento calculaQuantidadePares
		newline
		
		jal encontraMaiorPar # aplica o procedimento encontraMaiorPar e salva o endere�o dessa chamada de fun��o em $ra
		beq $v1, -2147483647, execaoEncontraMaiorPar # se o retorno do procedimento encontraMaiorPar for igual a -2147483647, significa que ocorreu uma exe��o, ent�o vai para o tratamento de exe��o execaoEncontraMaiorPar
			la $a0, mensagemMaiorPar # carrega a mensagem de retorno do procedimento encontraMaiorPar em $a0, para poder imprimi-la
			printString # imprime a mensagem de retorno do procedimento encontraMaiorPar
			la $a0, ($v1) # carrega o valor de retorno do procedimento  encontraMaiorPar em $a0, para poder imprimi-lo
			printInt # imprime o resultado do procedimento encontraMaiorPar
			newline
			j fimExecaoEncontraMaiorPar # pula o tratamento de exe��o execaoEncontraMaiorPar, pois o procedimento operou sem problemas
		execaoEncontraMaiorPar: # procedimento de tratamento de exe��o para o procedimento encontraMaiorPar
			la $a0, mensagemExecaoEncontraMaiorPar # carrega a mensagem de exe��o do procedimento encontraMaiorPar em $a0, para poder imprimi-la
			printString # imprime a mensagem de exe��o do procedimento encontraMaiorPar
			newline
		fimExecaoEncontraMaiorPar: # label para pular o tratamento de exe��o execaoEncontraMaiorPar caso o procedimento encontraMaiorPar opere sem problemas
		
		jal encontraMenorImpar # aplica o procedimento encontraMenorImpar e salva o endere�o dessa chamada de fun��o em $ra
		beq $v1, 2147483647, execaoEncontraMenorImpar # se o retorno do procedimento encontraMenorImpar for igual a 2147483647, significa que ocorreu uma exe��o, ent�o vai para o tratamento de exe��o execaoCalculaProdutoPares
			la $a0, mensagemMenorImpar # carrega a mensagem de retorno do procedimento encontraMenorImpar em $a0, para poder imprimi-la
			printString # imprime a mensagem de retorno do procedimento encontraMenorImpar
			la $a0, ($v1) # carrega o valor de retorno do procedimento  encontraMenorImpar em $a0, para poder imprimi-lo
			printInt # imprime o resultado do procedimento encontraMenorImpar
			newline
			j fimExecaoEncontraMenorImpar # pula o tratamento de exe��o execaoEncontraMenorImpar, pois o procedimento operou sem problemas
		execaoEncontraMenorImpar: # procedimento de tratamento de exe��o para o procedimento encontraMenorImpar
			la $a0, mensagemExecaoEncontraMenorImpar # carrega a mensagem de exe��o do procedimento encontraMenorImpar em $a0, para poder imprimi-la
			printString # imprime a mensagem de exe��o do procedimento encontraMenorImpar
			newline
		fimExecaoEncontraMenorImpar: # label para pular o tratamento de exe��o execaoEncontraMenorImpar caso o procedimento encontraMenorImpar opere sem problemas
		
		jal calculaSomaImpares # aplica o procedimento calculaSomaImpares e salva o endere�o dessa chamada de fun��o em $ra
		beq $v1, 0, execaoCalculaSomaImpares # se o retorno do procedimento calculaSomaImpares for igual a 0, significa que ocorreu uma exe��o, ent�o vai para o tratamento de exe��o execaoCalculaSomaImpares
			la $a0, mensagemSomaImpares # carrega a mensagem de retorno do procedimento calculaSomaImpares em $a0, para poder imprimi-la
			printString # imprime a mensagem de retorno do procedimento calculaSomaImpares
			la $a0, ($v1) # carrega o valor de retorno do procedimento  calculaSomaImpares em $a0, para poder imprimi-lo
			printInt # imprime o resultado do procedimento calculaSomaImpares
			newline
			j fimExecaoCalculaSomaImpares # pula o tratamento de exe��o execaoCalculaSomaImpares, pois o procedimento operou sem problemas
		execaoCalculaSomaImpares: # procedimento de tratamento de exe��o para o procedimento calculaSomaImpares
			la $a0, mensagemExecaoCalculaSomaImpares # carrega a mensagem de exe��o do procedimento calculaSomaImpares em $a0, para poder imprimi-la
			printString # imprime a mensagem de exe��o do procedimento calculaSomaImpares
			newline
		fimExecaoCalculaSomaImpares: # label para pular o tratamento de exe��o execaoCalculaSomaImpares caso o procedimento calculaSomaImpares opere sem problemas
		
		jal calculaProdutoPares # aplica o procedimento calculaProdutoPares e salva o endere�o dessa chamada de fun��o em $ra
		beq $v1, 1, execaoCalculaProdutoPares # se o retorno do procedimento calculaProdutoPares for igual a 1, significa que ocorreu uma exe��o, ent�o vai para o tratamento de exe��o execaoCalculaProdutoPares
			la $a0, mensagemProdutoPares # carrega a mensagem de retorno do procedimento calculaProdutoPares em $a0, para poder imprimi-la
			printString # imprime a mensagem de retorno do procedimento calculaProdutoPares
			la $a0, ($v1) # carrega o valor de retorno do procedimento  calculaProdutoPares em $a0, para poder imprimi-lo
			printInt # imprime o resultado do procedimento calculaProdutoPares
			endProgram
		execaoCalculaProdutoPares: # procedimento de tratamento de exe��o para o procedimento calculaProdutoPares
			la $a0, mensagemExecaoCalculaProdutoPares # carrega a mensagem de exe��o do procedimento calculaProdutoPares em $a0, para poder imprimi-la
			printString # imprime a mensagem de exe��o do procedimento calculaProdutoPares
			endProgram
		
		
	encontraMaior: # recebe o endere�o do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e retorna em $v1 o maior elemento do vetor
		# $t0 -> contador decrescente do loop do while loopEncontraMaior
		# $t1 -> ponteiro para o vetor
		# $t2 -> registrador tempor�rio para o maior valor do vetor
		# $t3 -> elemento que est� sendo testado
		# $t4 -> resultado da subtra��o, respons�vel pelo teste l�gico, se o valor atualmente testado � maior que o atual maior
		sub $t0, $a2, 1 # inicializa um contador decrescente com o tamanho do vetor - 1 em $t0
		add $t1, $a1, 4 # carrega em $t1 o endere�o do segundo elemento do vetor
		lw $t2, ($a1) # inicializa o registrador tempor�rio do maior valor, em $t2, como o valor do primeiro elemento do vetor
		loopEncontraMaior: # loop do while do procedimento encontraMaior para processar todos os elementos do vetor
			lw $t3, ($t1) # carrega $t3 com o valor do elemento a ser testado
			sub $t4, $t2, $t3 # subtrai o valor atualmente testado do atual maior valor e salva o resultado em $t4
			bgtz $t4, label1 # se o valor da subtra��o anterior for maior do que 0, quer dizer que o valor atualmente testado � menor que o atual maior, ent�o a linha seguinte � ignorada
				la $t2, ($t3) # se n�o ocorrer a situa�a� descrita acima, significa que o valor testado � maior que o atual maior, ent�o o valor testado � salvo como o novo maior
			label1: # label gen�rica para pular a linha anterior
			addi $t1, $t1, 4 # incrementa o ponteiro $t1 para apontar para o pr�ximo elemento do vetor
			subi $t0, $t0, 1 # decrementa o contador decrescente $t0
			bne $t0, $zero, loopEncontraMaior # enquanto o valor do contador $t0 for diferente de 0 reinicia o loop loopEncontraMaior
		la $v1, ($t2) # carrega o valor de $t2, que � a o maior elemento do vetor, para o registrador de retorno $v1  
		jr $ra # retorna ao endere�o de chamada da fun��o
		
	encontraMenor: # recebe o endere�o do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e retorna em $v1 o menor elemento do vetor
		# $t0 -> contador decrescente do loop do while loopEncontraMenor
		# $t1 -> ponteiro para o vetor
		# $t2 -> registrador tempor�rio para o menor valor do vetor
		# $t3 -> elemento que est� sendo testado
		# $t4 -> resultado da subtra��o, respons�vel pelo teste l�gico, se o valor atualmente testado � menor que o atual menor
		sub $t0, $a2, 1 # inicializa um contador decrescente com o tamanho do vetor - 1 em $t0
		add $t1, $a1, 4 # carrega em $t1 o endere�o do segundo elemento do vetor
		lw $t2, ($a1) # inicializa o registrador tempor�rio do menor valor, em $t2, como o valor do primeiro elemento do vetor
		loopEncontraMenor: # loop do while do procedimento encontraMenor para processar todos os elementos do vetor
			lw $t3, ($t1) # carrega $t3 com o valor do elemento a ser testado
			sub $t4, $t3, $t2 # subtrai o atual menor valor do atualmente testado e salva o resultado em $t4
			bgtz $t4, label2 # se o valor da subtra��o anterior for maior que 0, quer dizer que o valor atualmente testado � maior que o atual menor, ent�o a linha seguinte � ignorada 
				la $t2, ($t3) # se n�o ocorrer a situa�a� descrita acima, significa que o valor testado � menor que o atual menor, ent�o o valor testado � salvo como o novo menor
			label2: # label gen�rica para pular a linha anterior
			addi $t1, $t1, 4 # incrementa o ponteiro $t1 para apontar para o pr�ximo elemento do vetor
			subi $t0, $t0, 1 # decrementa o contador decrescente $t0
			bne $t0, $zero, loopEncontraMenor # enquanto o valor do contador $t0 for diferente de 0 reinicia o loop loopEncontraMenor
		la $v1, ($t2) # carrega o valor de $t2, que � a o menor elemento do vetor, para o registrador de retorno $v1  
		jr $ra # retorna ao endere�o de chamada da fun��o
		
	calculaQuantidadePares: # recebe o endere�o do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e retorna em $v1 a quantidade de n�meros pares
		# $t0 -> contador decrescente do loop do while loopCalculaQuantidadePares
		# $t1 -> ponteiro para o vetor
		# $t2 -> registrador tempor�rio para a quantidade de pares do vetor
		# $t3 -> valor do elemento que est� sendo testado
		# $t4 -> resto da divis�o: valor bin�rio, se o n�mero for par se torna 0 se for �mpar 1
		la $t0, ($a2) # inicializa um contador decrescente com o tamanho do vetor em $t0
		la $t1, ($a1) # carrega em $t1 o endere�o do primeiro elemento do vetor
		li $t2, 0 # inicializa o registrador tempor�rio de quantidade de pares do vetor, em $t2, com 0
		loopCalculaQuantidadePares: # loop do while do procedimento calculaQuantidadePares para processar todos os elementos do vetor
			lw $t3, ($t1) # carrega $t3 com o valor do elemento a ser testado
			div  $t4, $t3, 2 # divide por 2 o valor testado
			mfhi $t4  # salva o resto da divis�o anterior em $t4
			bne $t4, $zero, label3 # se o valor de $t4 for diferente de 0, quer dizer que o n�mero � �mpar ent�o salta por cima do incremento abaixo
				addi $t2, $t2, 1 # se n�o ocorrer a situa��o descrita acima, significa que o valor testado � par, ent�o incrementa o valor da quantidade de elementos pares em 1 
			label3: # label gen�rica para pular a linha anterior
			addi $t1, $t1, 4 # incrementa o ponteiro $t1 para apontar para apontar para o pr�ximo elemento do vetor
			subi $t0, $t0, 1 # decrementa o contador decrescente $t0
			bne $t0, $zero, loopCalculaQuantidadePares # enquanto o valor do contador $t0 for diferente de 0 reinicia o loop loopCalculaQuantidadePares
		la $v1, ($t2) # carrega o valor de $t2, que � a quantidade de elementos pares do vetor para o registrador de retorno $v1  
		jr $ra # retorna ao endere�o de chamada da fun��o
		
	encontraMaiorPar: # recebe o endere�o do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e retorna em $v1 o maior elemento par do vetor ou -2147483647 caso n�o exista n�meros pares no vetor
		# $t0 -> contador decrescente do loop do while loopEncontraMaiorPar
		# $t1 -> ponteiro para o vetor
		# $t2 -> registrador tempor�rio para o maior valor par do vetor
		# $t3 -> elemento que est� sendo testado
		# $t4 -> resultado da subtra��o, respons�vel pelo teste l�gico, se o valor atualmente testado � maior que o atual maior par
		# $t5 -> resto da divis�o: valor bin�rio, se o n�mero for par se torna 0 se for �mpar 1
		la $t0, ($a2) # inicializa um contador decrescente com o tamanho do vetor em $t0
		la $t1, ($a1) # carrega em $t1 o endere�o do primeiro elemento do vetor
		li $t2, -2147483647 # inicializa o registrador tempor�rio do maior elemento par do vetor, em $t2, com -2147483647, que � o menor valor �mpar poss�vel
		loopEncontraMaiorPar: # loop do while do procedimento encontraMaiorPar para processar todos os elementos do vetor
			lw $t3, ($t1) # carrega $t3 com o valor do elemento a ser testado
			div  $t5, $t3, 2 # divide por 2 o valor testado
			mfhi $t5  # salva o resto da divis�o anterior em $t5
			bne $t5, $zero, label4 # se o valor de $t5 for diferente de 0, quer dizer que o n�mero � �mpar ent�o salta por cima do bloco abaixo at� a label4
				sub $t4, $t2, $t3 # se n�o ocorrer a situa��o descrita acima, significa que o valor � par, ent�o subtrai o valor atualmente testado do atual maior valor
				bgtz $t4, label4 # se o valor da subtra��o anterior for maior do que 0, quer dizer que o valor atualmente testado � menor que o atual maior par, ent�o a linha seguinte � ignorada
					la $t2, ($t3) # se n�o ocorrer a situa�a� descrita acima, significa que o valor testado � um n�mero par maior que o atual maior par, ent�o o valor testado deve ser salvo como o novo maior par
			label4: # label gen�rica para pular o bloco ou a linha anteriores
			addi $t1, $t1, 4 # incrementa o ponteiro $t1 para apontar para o pr�ximo elemento do vetor
			subi $t0, $t0, 1 # decrementa o contador decrescente $t0
			bne $t0, $zero, loopEncontraMaiorPar # enquanto o valor do contador $t0 for diferente de 0 reinicia o loop loopEncontraMaiorPar
		la $v1, ($t2) # carrega o valor de $t2, que � a o maior elemento par do vetor, para o registrador de retorno $v1  
		jr $ra # retorna ao endere�o de chamada da fun��o
		
	encontraMenorImpar: # recebe o endere�o do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e retorna em $v1 o menor elemento �mpar do vetor ou 2147483647 caso n�o haja valores �mpares no vetor
		# $t0 -> contador decrescente do loop do while loopEncontraMenorImpar
		# $t1 -> ponteiro para o vetor
		# $t2 -> registrador tempor�rio para o menor valor �mpar do vetor
		# $t3 -> elemento que est� sendo testado
		# $t4 -> resultado da subtra��o, respons�vel pelo teste l�gico, se o valor atualmente testado � menor que o atual menor �mpar
		# $t5 -> resto da divis�o: valor bin�rio, se o n�mero for par se torna 0 se for �mpar 1
		la $t0, ($a2) # inicializa um contador decrescente com o tamanho do vetor em $t0
		la $t1, ($a1) # carrega em $t1 o endere�o do primeiro elemento do vetor
		li $t2, 2147483647 # inicializa o registrador tempor�rio do menor elemento �mpar do vetor, em $t2, com 2147483647, que � o maior valor �mpar poss�vel
		loopEncontraMenorImpar:  # loop do while do procedimento encontraMenorImpar para processar todos os elementos do vetor
			lw $t3, ($t1) # carrega $t3 com o valor do elemento a ser testado
			div  $t5, $t3, 2 # divide por 2 o valor testado
			mfhi $t5  # salva o resto da divis�o anterior em $t5
			beq $t5, $zero, label5 # se o valor de $t5 for igual a 0, quer dizer que o n�mero � par ent�o salta por cima do bloco abaixo at� a label5
				sub $t4, $t3, $t2 # se n�o ocorrer a situa��o descrita acima, significa que o valor � �mpar, ent�o subtrai o atual menor valor do atualmente testado e salva o resultado em $t4
				bgtz $t4, label5 # se o valor da subtra��o anterior for maior que 0, quer dizer que o valor atualmente testado � maior que o atual menor �mpar, ent�o a linha seguinte � ignorada
					la $t2, ($t3) # se n�o ocorrer a situa�a� descrita acima, significa que o valor testado � um �mpar menor que o atual menor �mpar, ent�o o valor testado deve ser salvo como o novo menor �mpar
			label5: # label gen�rica para pular o bloco ou a linha anteriores
			addi $t1, $t1, 4 # incrementa o ponteiro $t1 para apontar para o pr�ximo elemento do vetor
			subi $t0, $t0, 1 # decrementa o contador decrescente $t0
			bne $t0, $zero, loopEncontraMenorImpar # enquanto o valor do contador $t0 for diferente de 0 reinicia o loop loopEncontraMenorImpar
		la $v1, ($t2) # carrega o valor de $t2, que � a o menor elemento �mpar do vetor, para o registrador de retorno $v1  
		jr $ra # retorna ao endere�o de chamada da fun��o
		
	calculaSomaImpares: # recebe o endere�o do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e retorna em $v1 a soma dos valores dos elementos �mpares do vetor ou 0 se n�o existir nenhum n�mero �mpar no vetor 
		# $t0 -> contador de itera��es do loop do while loopCalculaSomaImpares
		# $t1 -> ponteiro para o vetor
		# $t2 -> registrador tempor�rio para a soma dos elementos �mpares do vetor
		# $t3 -> valor do elemento que est� sendo testado
		# $t4 -> resto da divis�o: valor bin�rio, se o n�mero for par se torna 0 se for �mpar 1
		la $t0, ($a2) # inicializa um contador decrescente com o tamanho do vetor em $t0
		la $t1, ($a1) # carrega em $t1 o endere�o do primeiro elemento do vetor
		li $t2, 0 # inicializa o registrador tempor�rio da soma dos elementos �mpares do vetor, em $t2, com 0
		loopCalculaSomaImpares: # loop do while do procedimento calculaSomaImpares para processar todos os elementos do vetor
			lw $t3, ($t1) # carrega $t3 com o valor do elemento a ser testado
			div  $t4, $t3, 2 # divide por 2 o valor testado
			mfhi $t4  # salva o resto da divis�o anterior em $t4
			beq $t4, $zero, label6 # se o valor de $t4 for igual a 0, quer dizer que o n�mero � par ent�o salta por cima da linha abaixo
				add $t2, $t2, $t3 # se n�o ocorrer a situa��o descrita acima, significa que o n�mero � �mpar, ent�o soma a soma de n�meros �mpares atual com o n�mero �mpar processado atualmente
			label6: # label gen�rica para pular a linha anterior
			subi $t0, $t0, 1 # decrementa o contador decrescente $t0
			addi $t1, $t1, 4 # incrementa o ponteiro $t1 para apontar para o pr�ximo elemento do vetor
			bne $t0, $zero, loopCalculaSomaImpares # enquanto o valor do contador $t0 for diferente de 0 reinicia o loop loopCalculaSomaImpares
		la $v1, ($t2) # carrega o valor de $t2, que � a soma dos elementos �mpares do vetor para o registrador de retorno $v1  
		jr $ra # retorna ao endere�o de chamada da fun��o
		
	calculaProdutoPares: # recebe o endere�o do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e retorna em $v1 o produto dos valores dos elementos pares do vetor ou 1 se n�o existir nenhum n�mero par no vetor
		# $t0 -> contador de itera��es do loop do while loopCalculaProdutoPares
		# $t1 -> ponteiro para o vetor
		# $t2 -> registrador tempor�rio para o produto dos elementos pares do vetor
		# $t3 -> valor do elemento que est� sendo testado
		# $t4 -> resto da divis�o: valor bin�rio, se o n�mero for par se torna 0 se for �mpar 1
		la $t0, ($a2) # inicializa um contador decrescente com o tamanho do vetor em $t0
		la $t1, ($a1) # carrega em $t1 o endere�o do primeiro elemento do vetor
		li $t2, 1 # inicializa o registrador tempor�rio do produto dos elementos pares do vetor, em $t2, com 1
		loopCalculaProdutoPares: # loop do while do procedimento calculaProdutoPares para processar todos os elementos do vetor
			lw $t3, ($t1) # carrega $t3 com o valor do elemento a ser testado
			div  $t4, $t3, 2 # divide por 2 o valor testado
			mfhi $t4  # salva o resto da divis�o anterior em $t4
			bne $t4, $zero, label7 # se o valor de $t4 for diferente de 0, quer dizer que o n�mero � �mpar ent�o salta por cima da linha abaixo
				mul $t2, $t2, $t3 # se n�o ocorrer a situa��o descrita acima, significa que o n�mero � par, ent�o multiplica o produto de pares atual pelo n�mero par processado atualmente
			label7: # label gen�rica para pular a linha anterior
			subi $t0, $t0, 1 # decrementa o contador decrescente $t0
			addi $t1, $t1, 4 # incrementa o ponteiro $t1 para apontar para o pr�ximo elemento do vetor
			bne $t0, $zero, loopCalculaProdutoPares # enquanto o valor do contador $t0 for diferente de 0 reinicia o loop loopCalculaProdutoPares
		la $v1, ($t2) # carrega o valor de $t2, que � o produto dos elementos pares do vetor para o registrador de retorno $v1  
		jr $ra # retorna ao endere�o de chamada da fun��o