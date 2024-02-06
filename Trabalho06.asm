.data
	vet: .word 1,1,1,1,1,1,1,1,1,1
	
	charNewline: .asciiz "\n"
	
	mensagemMaior: .asciiz  "O maior elemento do vetor é: "
	mensagemMenor: .asciiz  "O menor elemento do vetor é: "
	mensagemQuantidadePares: .asciiz  "A quantidade de números pares do vetor é: "
	mensagemMaiorPar: .asciiz  "O maior elemento par do vetor é: "
	mensagemMenorImpar: .asciiz  "O menor elemento ímpar do vetor é: "
	mensagemSomaImpares: .asciiz  "A soma dos elementos ímpares do vetor é: "
	mensagemProdutoPares: .asciiz  "O produto dos elementos pares do vetor é: "
	
	mensagemExecaoEncontraMaiorPar: .asciiz "Não existe nenhum par no vetor, portanto o maior par não pode ser encontrado."
	mensagemExecaoEncontraMenorImpar: .asciiz "Não existe nenhum ímpar no vetor, portanto o menor ímpar não pode ser encontrado."
	mensagemExecaoCalculaSomaImpares: .asciiz "Não existe nenhum ímpar no vetor, portanto a soma dos elementos ímpares não pode ser calculada."
	mensagemExecaoCalculaProdutoPares: .asciiz "Não existe nenhum par no vetor, portanto o produto dos elementos pares não pode ser calculado."
	
	# $a0 -> parâmetros para syscall
	# $a1 -> parâmetro vetor de inteiros para os procedimentos de análise de vetor
	# $a2 -> parâmetro inteiro: comprimento do vetor para os procedimentos de análise de vetor
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
		la $a1, vet # carrega no registrador $a1 o endereço do primeiro elemento do vetor a ser passado como parâmetro para as funções
		li $a2, 10 # carrega no registrador $a2 o comprimento do vetor a ser passado como parâmetro no $a1
		
		jal encontraMaior # aplica o procedimento encontraMaior e salva o endereço dessa chamada de função em $ra
		la $a0, mensagemMaior # carrega a mensagem de retorno do procedimento encontraMaior em $a0, para poder imprimi-la
		printString # imprime a mensagem de retorno do procedimento encontraMaior
		la $a0, ($v1) # carrega o valor de retorno do procedimento encontraMaior em $a0, para poder imprimi-lo
		printInt # imprime o resultado do procedimento encontraMaior
		newline
		
		jal encontraMenor # aplica o procedimento encontraMenor e salva o endereço dessa chamada de função em $ra
		la $a0, mensagemMenor # carrega a mensagem de retorno do procedimento encontraMenor em $a0, para poder imprimi-la
		printString # imprime a mensagem de retorno do procedimento encontraMenor
		la $a0, ($v1) # carrega o valor de retorno do procedimento  encontraMenor em $a0, para poder imprimi-lo
		printInt # imprime o retorno do procedimento encontraMenor
		newline
		
		jal calculaQuantidadePares # aplica o procedimento calculaQuantidadePares e salva o endereço dessa chamada de função em $ra
		la $a0, mensagemQuantidadePares # carrega a mensagem de retorno do procedimento calculaQuantidadePares em $a0, para poder imprimi-la
		printString # imprime a mensagem de retorno do procedimento calculaQuantidadePares
		la $a0, ($v1) # carrega o valor de retorno do procedimento  calculaQuantidadePares em $a0, para poder imprimi-lo
		printInt # imprime o resultado do procedimento calculaQuantidadePares
		newline
		
		jal encontraMaiorPar # aplica o procedimento encontraMaiorPar e salva o endereço dessa chamada de função em $ra
		beq $v1, -2147483647, execaoEncontraMaiorPar # se o retorno do procedimento encontraMaiorPar for igual a -2147483647, significa que ocorreu uma exeção, então vai para o tratamento de exeção execaoEncontraMaiorPar
			la $a0, mensagemMaiorPar # carrega a mensagem de retorno do procedimento encontraMaiorPar em $a0, para poder imprimi-la
			printString # imprime a mensagem de retorno do procedimento encontraMaiorPar
			la $a0, ($v1) # carrega o valor de retorno do procedimento  encontraMaiorPar em $a0, para poder imprimi-lo
			printInt # imprime o resultado do procedimento encontraMaiorPar
			newline
			j fimExecaoEncontraMaiorPar # pula o tratamento de exeção execaoEncontraMaiorPar, pois o procedimento operou sem problemas
		execaoEncontraMaiorPar: # procedimento de tratamento de exeção para o procedimento encontraMaiorPar
			la $a0, mensagemExecaoEncontraMaiorPar # carrega a mensagem de exeção do procedimento encontraMaiorPar em $a0, para poder imprimi-la
			printString # imprime a mensagem de exeção do procedimento encontraMaiorPar
			newline
		fimExecaoEncontraMaiorPar: # label para pular o tratamento de exeção execaoEncontraMaiorPar caso o procedimento encontraMaiorPar opere sem problemas
		
		jal encontraMenorImpar # aplica o procedimento encontraMenorImpar e salva o endereço dessa chamada de função em $ra
		beq $v1, 2147483647, execaoEncontraMenorImpar # se o retorno do procedimento encontraMenorImpar for igual a 2147483647, significa que ocorreu uma exeção, então vai para o tratamento de exeção execaoCalculaProdutoPares
			la $a0, mensagemMenorImpar # carrega a mensagem de retorno do procedimento encontraMenorImpar em $a0, para poder imprimi-la
			printString # imprime a mensagem de retorno do procedimento encontraMenorImpar
			la $a0, ($v1) # carrega o valor de retorno do procedimento  encontraMenorImpar em $a0, para poder imprimi-lo
			printInt # imprime o resultado do procedimento encontraMenorImpar
			newline
			j fimExecaoEncontraMenorImpar # pula o tratamento de exeção execaoEncontraMenorImpar, pois o procedimento operou sem problemas
		execaoEncontraMenorImpar: # procedimento de tratamento de exeção para o procedimento encontraMenorImpar
			la $a0, mensagemExecaoEncontraMenorImpar # carrega a mensagem de exeção do procedimento encontraMenorImpar em $a0, para poder imprimi-la
			printString # imprime a mensagem de exeção do procedimento encontraMenorImpar
			newline
		fimExecaoEncontraMenorImpar: # label para pular o tratamento de exeção execaoEncontraMenorImpar caso o procedimento encontraMenorImpar opere sem problemas
		
		jal calculaSomaImpares # aplica o procedimento calculaSomaImpares e salva o endereço dessa chamada de função em $ra
		beq $v1, 0, execaoCalculaSomaImpares # se o retorno do procedimento calculaSomaImpares for igual a 0, significa que ocorreu uma exeção, então vai para o tratamento de exeção execaoCalculaSomaImpares
			la $a0, mensagemSomaImpares # carrega a mensagem de retorno do procedimento calculaSomaImpares em $a0, para poder imprimi-la
			printString # imprime a mensagem de retorno do procedimento calculaSomaImpares
			la $a0, ($v1) # carrega o valor de retorno do procedimento  calculaSomaImpares em $a0, para poder imprimi-lo
			printInt # imprime o resultado do procedimento calculaSomaImpares
			newline
			j fimExecaoCalculaSomaImpares # pula o tratamento de exeção execaoCalculaSomaImpares, pois o procedimento operou sem problemas
		execaoCalculaSomaImpares: # procedimento de tratamento de exeção para o procedimento calculaSomaImpares
			la $a0, mensagemExecaoCalculaSomaImpares # carrega a mensagem de exeção do procedimento calculaSomaImpares em $a0, para poder imprimi-la
			printString # imprime a mensagem de exeção do procedimento calculaSomaImpares
			newline
		fimExecaoCalculaSomaImpares: # label para pular o tratamento de exeção execaoCalculaSomaImpares caso o procedimento calculaSomaImpares opere sem problemas
		
		jal calculaProdutoPares # aplica o procedimento calculaProdutoPares e salva o endereço dessa chamada de função em $ra
		beq $v1, 1, execaoCalculaProdutoPares # se o retorno do procedimento calculaProdutoPares for igual a 1, significa que ocorreu uma exeção, então vai para o tratamento de exeção execaoCalculaProdutoPares
			la $a0, mensagemProdutoPares # carrega a mensagem de retorno do procedimento calculaProdutoPares em $a0, para poder imprimi-la
			printString # imprime a mensagem de retorno do procedimento calculaProdutoPares
			la $a0, ($v1) # carrega o valor de retorno do procedimento  calculaProdutoPares em $a0, para poder imprimi-lo
			printInt # imprime o resultado do procedimento calculaProdutoPares
			endProgram
		execaoCalculaProdutoPares: # procedimento de tratamento de exeção para o procedimento calculaProdutoPares
			la $a0, mensagemExecaoCalculaProdutoPares # carrega a mensagem de exeção do procedimento calculaProdutoPares em $a0, para poder imprimi-la
			printString # imprime a mensagem de exeção do procedimento calculaProdutoPares
			endProgram
		
		
	encontraMaior: # recebe o endereço do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e retorna em $v1 o maior elemento do vetor
		# $t0 -> contador decrescente do loop do while loopEncontraMaior
		# $t1 -> ponteiro para o vetor
		# $t2 -> registrador temporário para o maior valor do vetor
		# $t3 -> elemento que está sendo testado
		# $t4 -> resultado da subtração, responsável pelo teste lógico, se o valor atualmente testado é maior que o atual maior
		sub $t0, $a2, 1 # inicializa um contador decrescente com o tamanho do vetor - 1 em $t0
		add $t1, $a1, 4 # carrega em $t1 o endereço do segundo elemento do vetor
		lw $t2, ($a1) # inicializa o registrador temporário do maior valor, em $t2, como o valor do primeiro elemento do vetor
		loopEncontraMaior: # loop do while do procedimento encontraMaior para processar todos os elementos do vetor
			lw $t3, ($t1) # carrega $t3 com o valor do elemento a ser testado
			sub $t4, $t2, $t3 # subtrai o valor atualmente testado do atual maior valor e salva o resultado em $t4
			bgtz $t4, label1 # se o valor da subtração anterior for maior do que 0, quer dizer que o valor atualmente testado é menor que o atual maior, então a linha seguinte é ignorada
				la $t2, ($t3) # se não ocorrer a situaçaõ descrita acima, significa que o valor testado é maior que o atual maior, então o valor testado é salvo como o novo maior
			label1: # label genérica para pular a linha anterior
			addi $t1, $t1, 4 # incrementa o ponteiro $t1 para apontar para o próximo elemento do vetor
			subi $t0, $t0, 1 # decrementa o contador decrescente $t0
			bne $t0, $zero, loopEncontraMaior # enquanto o valor do contador $t0 for diferente de 0 reinicia o loop loopEncontraMaior
		la $v1, ($t2) # carrega o valor de $t2, que é a o maior elemento do vetor, para o registrador de retorno $v1  
		jr $ra # retorna ao endereço de chamada da função
		
	encontraMenor: # recebe o endereço do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e retorna em $v1 o menor elemento do vetor
		# $t0 -> contador decrescente do loop do while loopEncontraMenor
		# $t1 -> ponteiro para o vetor
		# $t2 -> registrador temporário para o menor valor do vetor
		# $t3 -> elemento que está sendo testado
		# $t4 -> resultado da subtração, responsável pelo teste lógico, se o valor atualmente testado é menor que o atual menor
		sub $t0, $a2, 1 # inicializa um contador decrescente com o tamanho do vetor - 1 em $t0
		add $t1, $a1, 4 # carrega em $t1 o endereço do segundo elemento do vetor
		lw $t2, ($a1) # inicializa o registrador temporário do menor valor, em $t2, como o valor do primeiro elemento do vetor
		loopEncontraMenor: # loop do while do procedimento encontraMenor para processar todos os elementos do vetor
			lw $t3, ($t1) # carrega $t3 com o valor do elemento a ser testado
			sub $t4, $t3, $t2 # subtrai o atual menor valor do atualmente testado e salva o resultado em $t4
			bgtz $t4, label2 # se o valor da subtração anterior for maior que 0, quer dizer que o valor atualmente testado é maior que o atual menor, então a linha seguinte é ignorada 
				la $t2, ($t3) # se não ocorrer a situaçaõ descrita acima, significa que o valor testado é menor que o atual menor, então o valor testado é salvo como o novo menor
			label2: # label genérica para pular a linha anterior
			addi $t1, $t1, 4 # incrementa o ponteiro $t1 para apontar para o próximo elemento do vetor
			subi $t0, $t0, 1 # decrementa o contador decrescente $t0
			bne $t0, $zero, loopEncontraMenor # enquanto o valor do contador $t0 for diferente de 0 reinicia o loop loopEncontraMenor
		la $v1, ($t2) # carrega o valor de $t2, que é a o menor elemento do vetor, para o registrador de retorno $v1  
		jr $ra # retorna ao endereço de chamada da função
		
	calculaQuantidadePares: # recebe o endereço do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e retorna em $v1 a quantidade de números pares
		# $t0 -> contador decrescente do loop do while loopCalculaQuantidadePares
		# $t1 -> ponteiro para o vetor
		# $t2 -> registrador temporário para a quantidade de pares do vetor
		# $t3 -> valor do elemento que está sendo testado
		# $t4 -> resto da divisão: valor binário, se o número for par se torna 0 se for ímpar 1
		la $t0, ($a2) # inicializa um contador decrescente com o tamanho do vetor em $t0
		la $t1, ($a1) # carrega em $t1 o endereço do primeiro elemento do vetor
		li $t2, 0 # inicializa o registrador temporário de quantidade de pares do vetor, em $t2, com 0
		loopCalculaQuantidadePares: # loop do while do procedimento calculaQuantidadePares para processar todos os elementos do vetor
			lw $t3, ($t1) # carrega $t3 com o valor do elemento a ser testado
			div  $t4, $t3, 2 # divide por 2 o valor testado
			mfhi $t4  # salva o resto da divisão anterior em $t4
			bne $t4, $zero, label3 # se o valor de $t4 for diferente de 0, quer dizer que o número é ímpar então salta por cima do incremento abaixo
				addi $t2, $t2, 1 # se não ocorrer a situação descrita acima, significa que o valor testado é par, então incrementa o valor da quantidade de elementos pares em 1 
			label3: # label genérica para pular a linha anterior
			addi $t1, $t1, 4 # incrementa o ponteiro $t1 para apontar para apontar para o próximo elemento do vetor
			subi $t0, $t0, 1 # decrementa o contador decrescente $t0
			bne $t0, $zero, loopCalculaQuantidadePares # enquanto o valor do contador $t0 for diferente de 0 reinicia o loop loopCalculaQuantidadePares
		la $v1, ($t2) # carrega o valor de $t2, que é a quantidade de elementos pares do vetor para o registrador de retorno $v1  
		jr $ra # retorna ao endereço de chamada da função
		
	encontraMaiorPar: # recebe o endereço do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e retorna em $v1 o maior elemento par do vetor ou -2147483647 caso não exista números pares no vetor
		# $t0 -> contador decrescente do loop do while loopEncontraMaiorPar
		# $t1 -> ponteiro para o vetor
		# $t2 -> registrador temporário para o maior valor par do vetor
		# $t3 -> elemento que está sendo testado
		# $t4 -> resultado da subtração, responsável pelo teste lógico, se o valor atualmente testado é maior que o atual maior par
		# $t5 -> resto da divisão: valor binário, se o número for par se torna 0 se for ímpar 1
		la $t0, ($a2) # inicializa um contador decrescente com o tamanho do vetor em $t0
		la $t1, ($a1) # carrega em $t1 o endereço do primeiro elemento do vetor
		li $t2, -2147483647 # inicializa o registrador temporário do maior elemento par do vetor, em $t2, com -2147483647, que é o menor valor ímpar possível
		loopEncontraMaiorPar: # loop do while do procedimento encontraMaiorPar para processar todos os elementos do vetor
			lw $t3, ($t1) # carrega $t3 com o valor do elemento a ser testado
			div  $t5, $t3, 2 # divide por 2 o valor testado
			mfhi $t5  # salva o resto da divisão anterior em $t5
			bne $t5, $zero, label4 # se o valor de $t5 for diferente de 0, quer dizer que o número é ímpar então salta por cima do bloco abaixo até a label4
				sub $t4, $t2, $t3 # se não ocorrer a situação descrita acima, significa que o valor é par, então subtrai o valor atualmente testado do atual maior valor
				bgtz $t4, label4 # se o valor da subtração anterior for maior do que 0, quer dizer que o valor atualmente testado é menor que o atual maior par, então a linha seguinte é ignorada
					la $t2, ($t3) # se não ocorrer a situaçaõ descrita acima, significa que o valor testado é um número par maior que o atual maior par, então o valor testado deve ser salvo como o novo maior par
			label4: # label genérica para pular o bloco ou a linha anteriores
			addi $t1, $t1, 4 # incrementa o ponteiro $t1 para apontar para o próximo elemento do vetor
			subi $t0, $t0, 1 # decrementa o contador decrescente $t0
			bne $t0, $zero, loopEncontraMaiorPar # enquanto o valor do contador $t0 for diferente de 0 reinicia o loop loopEncontraMaiorPar
		la $v1, ($t2) # carrega o valor de $t2, que é a o maior elemento par do vetor, para o registrador de retorno $v1  
		jr $ra # retorna ao endereço de chamada da função
		
	encontraMenorImpar: # recebe o endereço do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e retorna em $v1 o menor elemento ímpar do vetor ou 2147483647 caso não haja valores ímpares no vetor
		# $t0 -> contador decrescente do loop do while loopEncontraMenorImpar
		# $t1 -> ponteiro para o vetor
		# $t2 -> registrador temporário para o menor valor ímpar do vetor
		# $t3 -> elemento que está sendo testado
		# $t4 -> resultado da subtração, responsável pelo teste lógico, se o valor atualmente testado é menor que o atual menor ímpar
		# $t5 -> resto da divisão: valor binário, se o número for par se torna 0 se for ímpar 1
		la $t0, ($a2) # inicializa um contador decrescente com o tamanho do vetor em $t0
		la $t1, ($a1) # carrega em $t1 o endereço do primeiro elemento do vetor
		li $t2, 2147483647 # inicializa o registrador temporário do menor elemento ímpar do vetor, em $t2, com 2147483647, que é o maior valor ímpar possível
		loopEncontraMenorImpar:  # loop do while do procedimento encontraMenorImpar para processar todos os elementos do vetor
			lw $t3, ($t1) # carrega $t3 com o valor do elemento a ser testado
			div  $t5, $t3, 2 # divide por 2 o valor testado
			mfhi $t5  # salva o resto da divisão anterior em $t5
			beq $t5, $zero, label5 # se o valor de $t5 for igual a 0, quer dizer que o número é par então salta por cima do bloco abaixo até a label5
				sub $t4, $t3, $t2 # se não ocorrer a situação descrita acima, significa que o valor é ímpar, então subtrai o atual menor valor do atualmente testado e salva o resultado em $t4
				bgtz $t4, label5 # se o valor da subtração anterior for maior que 0, quer dizer que o valor atualmente testado é maior que o atual menor ímpar, então a linha seguinte é ignorada
					la $t2, ($t3) # se não ocorrer a situaçaõ descrita acima, significa que o valor testado é um ímpar menor que o atual menor ímpar, então o valor testado deve ser salvo como o novo menor ímpar
			label5: # label genérica para pular o bloco ou a linha anteriores
			addi $t1, $t1, 4 # incrementa o ponteiro $t1 para apontar para o próximo elemento do vetor
			subi $t0, $t0, 1 # decrementa o contador decrescente $t0
			bne $t0, $zero, loopEncontraMenorImpar # enquanto o valor do contador $t0 for diferente de 0 reinicia o loop loopEncontraMenorImpar
		la $v1, ($t2) # carrega o valor de $t2, que é a o menor elemento ímpar do vetor, para o registrador de retorno $v1  
		jr $ra # retorna ao endereço de chamada da função
		
	calculaSomaImpares: # recebe o endereço do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e retorna em $v1 a soma dos valores dos elementos ímpares do vetor ou 0 se não existir nenhum número ímpar no vetor 
		# $t0 -> contador de iterações do loop do while loopCalculaSomaImpares
		# $t1 -> ponteiro para o vetor
		# $t2 -> registrador temporário para a soma dos elementos ímpares do vetor
		# $t3 -> valor do elemento que está sendo testado
		# $t4 -> resto da divisão: valor binário, se o número for par se torna 0 se for ímpar 1
		la $t0, ($a2) # inicializa um contador decrescente com o tamanho do vetor em $t0
		la $t1, ($a1) # carrega em $t1 o endereço do primeiro elemento do vetor
		li $t2, 0 # inicializa o registrador temporário da soma dos elementos ímpares do vetor, em $t2, com 0
		loopCalculaSomaImpares: # loop do while do procedimento calculaSomaImpares para processar todos os elementos do vetor
			lw $t3, ($t1) # carrega $t3 com o valor do elemento a ser testado
			div  $t4, $t3, 2 # divide por 2 o valor testado
			mfhi $t4  # salva o resto da divisão anterior em $t4
			beq $t4, $zero, label6 # se o valor de $t4 for igual a 0, quer dizer que o número é par então salta por cima da linha abaixo
				add $t2, $t2, $t3 # se não ocorrer a situação descrita acima, significa que o número é ímpar, então soma a soma de números ímpares atual com o número ímpar processado atualmente
			label6: # label genérica para pular a linha anterior
			subi $t0, $t0, 1 # decrementa o contador decrescente $t0
			addi $t1, $t1, 4 # incrementa o ponteiro $t1 para apontar para o próximo elemento do vetor
			bne $t0, $zero, loopCalculaSomaImpares # enquanto o valor do contador $t0 for diferente de 0 reinicia o loop loopCalculaSomaImpares
		la $v1, ($t2) # carrega o valor de $t2, que é a soma dos elementos ímpares do vetor para o registrador de retorno $v1  
		jr $ra # retorna ao endereço de chamada da função
		
	calculaProdutoPares: # recebe o endereço do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e retorna em $v1 o produto dos valores dos elementos pares do vetor ou 1 se não existir nenhum número par no vetor
		# $t0 -> contador de iterações do loop do while loopCalculaProdutoPares
		# $t1 -> ponteiro para o vetor
		# $t2 -> registrador temporário para o produto dos elementos pares do vetor
		# $t3 -> valor do elemento que está sendo testado
		# $t4 -> resto da divisão: valor binário, se o número for par se torna 0 se for ímpar 1
		la $t0, ($a2) # inicializa um contador decrescente com o tamanho do vetor em $t0
		la $t1, ($a1) # carrega em $t1 o endereço do primeiro elemento do vetor
		li $t2, 1 # inicializa o registrador temporário do produto dos elementos pares do vetor, em $t2, com 1
		loopCalculaProdutoPares: # loop do while do procedimento calculaProdutoPares para processar todos os elementos do vetor
			lw $t3, ($t1) # carrega $t3 com o valor do elemento a ser testado
			div  $t4, $t3, 2 # divide por 2 o valor testado
			mfhi $t4  # salva o resto da divisão anterior em $t4
			bne $t4, $zero, label7 # se o valor de $t4 for diferente de 0, quer dizer que o número é ímpar então salta por cima da linha abaixo
				mul $t2, $t2, $t3 # se não ocorrer a situação descrita acima, significa que o número é par, então multiplica o produto de pares atual pelo número par processado atualmente
			label7: # label genérica para pular a linha anterior
			subi $t0, $t0, 1 # decrementa o contador decrescente $t0
			addi $t1, $t1, 4 # incrementa o ponteiro $t1 para apontar para o próximo elemento do vetor
			bne $t0, $zero, loopCalculaProdutoPares # enquanto o valor do contador $t0 for diferente de 0 reinicia o loop loopCalculaProdutoPares
		la $v1, ($t2) # carrega o valor de $t2, que é o produto dos elementos pares do vetor para o registrador de retorno $v1  
		jr $ra # retorna ao endereço de chamada da função