.macro newline # quebra linha
	li $a0, 10 # Código ASCII para ("\n")	
	li $v0, 11 # Código de impressão de caractere
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

.macro printString (%str) # imprime diretamente a string inserida como parâmetro
	.data
		macroLabel: .asciiz %str
	.text
		li $v0, 4 # código de impressão de String
		la $a0, macroLabel
		syscall
.end_macro

.macro endProgram # encerra o programa
	li $v0, 10
	syscall
.end_macro

.macro readFile(%fileAddress, %readFileBuffer) # Lê o arquivo do endereço fornecido como 1º parâmetro, copia o arquivo para o endereço do 2º parâmetro e retorna em $s0 o file descriptor e em $s1 a quantidade de caracteres desse arquivo
	.data
		readFileFileAddress: .asciiz %fileAddress
		readFileError: .asciiz "ERROR: Arquivo não encontrado."
	.text
		li $v0, 13
		la $a0, readFileFileAddress
		li $a1, 0 # Código para read only
		syscall
		bgez $v0, readFileSucess
		la $a0, readFileError 
		li $v0, 4
		syscall
		li $v0, 10
		syscall
		readFileSucess:
			move $s0, $v0 # salva em $s0 o file descriptor
			li $v0 14
			move $a0, $s0
			la $a1, %readFileBuffer
			li $a2, 1024
			syscall
			move $s1, $v0
.end_macro

.macro closeFile # Fecha o arquivo que o descritor está armazenado em $s0
	li $v0, 16
	move $a0, $s0
	syscall
.end_macro

.data

	readFileBufferIntVector: .space 1024
	readFileBuffer: .space 1024 
	
.text

	Main:
		printString("O Arquivo lido possui ")
		readFile("dados1.txt", readFileBuffer)
		printInt($s1)
		printString(" Caracteres.")
		closeFile
		newline
		
		la $a1, readFileBuffer
		la $a2, readFileBufferIntVector
		jal stringToIntVector
		
		printString("O Arquivo lido possui os seguintes números: ")
		newline
		la $a1, readFileBufferIntVector
		la $a2, ($v1)
		jal printVetorInt
		newline
		
		printString("O maior número desse arquivo é: ")
		jal encontraMaiorElementoVetor
		printInt($v1)
		newline
		
		printString("O menor número desse arquivo é: ")
		jal encontraMenorElementoVetor
		printInt($v1)
		newline
		
		printString("A soma dos números desse arquivo é: ")
		jal somaVetor
		printInt($v1)
		newline
		
		printString("O produto dos números desse arquivo é: ")
		jal multiplicaVetor
		printInt($v1)
		newline
		
		printString("A quantidade de números pares desse arquivo é: ")
		jal quantificaParesVetor
		printInt($v1)
		newline
		
		printString("A quantidade de números ímpares desse arquivo é: ")
		jal quantificaImparesVetor
		printInt($v1)
		newline
		
		printString("Os números desse arquivo ordenados de forma crescente ficam: ")
		newline
		jal ordenaVetorCrescente
		jal printVetorInt
		newline
		
		printString("Os números desse arquivo ordenados de forma decrescente ficam: ")
		newline
		jal printVetorIntReverso
		newline
		
		endProgram
		
	stringToIntVector: # Recebe em $a1 o endereço do primeiro elemento de uma String de inteiros separados por espaço, cria um vetor de inteiros no endereço recebido em $a2 e retorna o comprimento desse vetor em $v1
		# :$t0 -> ponteiro para o caracter da String atualmente processado
		# $t1 -> caracter da String atualmente processado
		# $t2 -> ponteiro para o próximo elemento vazio do vetor de retorno
		# $t4 -> Auxiliar que armazena temporariamente o inteiro a ser armazenado no vetor 
		# $t5 -> bolleano que marca se a função deve ser encerrada depois de armazenar o próximo número no vetor de saída ou não
		# $t6 -> contador da quantidade de dígitos do número sendo convertido atualmente de String para int
		la $v1, ($zero) # Inicia o registrador de retorno do comprimento do vetor de retorno $v1 com 0
		la $t0, ($a1) # Carrega no ponteiro o endereço do primeiro caracter da String a ser convertida
		la $t2, ($a2) # Carrega no ponteiro o endereço do primeiro elemento vazio do vetor de retorno
		la $t4, ($zero) # Inicia o registrador $t3 com 0
		la $t5, ($zero) # Inicia o bolleano $t5 com 0
		la $t6, ($zero) # Inicia o contador $t6 com 0
		loopStringToIntVector:
			lb $t1, ($t0) # Carrega em $t1 o caracter da String apontado pelo ponteiro $t0
			addi $t0, $t0, 1 # Incrementa o ponteiro para a String de entrada $t0, para o próximo caracter
			ble $t1, 31, triggerEndStringToIntVector # Se o valor de $t1 for menor ou igual à 31 significa que foi lido um sinal de controle, por isso a função deve ser encerrada
			beq $t1, 32, nextIntStringToIntVector # Se o caracter na String for um espaço termina de registrar o inteiro atual e vai para o próximo
			ble $t1, 47, errorStringToIntVector # Se o valor na tabaela ASCII for menor ou igual à 47 não é um dígito numérico então acontece um erro na função
			bge $t1, 58, errorStringToIntVector # Se o valor na tabaela ASCII for maior ou igual à 58 não é um dígito numérico então acontece um erro na função
			subi $t3, $t1, 48 # Subtrai 48 do valor armazenado em $t1, para converter de valor de tabela ASCII para o valor numérico normal e salva em $t3  
			blez $t6, whateverLabel # Se a quantidade de dígitos do número sendo convertido atualmente de String para int em $t6 for menor ou igual à 0 não se deve realisar a linha abaixo
				mulo $t4, $t4, 10 # Multiplica a soma presente em $t4 por 10 para adicionar 1 casa decimal
			whateverLabel:
			add $t4, $t4, $t3 # Soma ao valor de $t4 o valor de $t3 
			addi $t6, $t6, 1 # Incrementa em 1 o contador da quantidade de dígitos do número sendo convertido atualmente de String para int $t6
			j loopStringToIntVector # Repete loopStringToIntVector até finalisar a função por erro ou pelo fim da String
			triggerEndStringToIntVector:
				li $t5, 1 # Carrega 1 no registrador $t5 para indicar que a função deve ser encerrada assim que armazenar o próximo número no vetor de saída  
			nextIntStringToIntVector:
				sw $t4, ($t2) # Salva o valor armazenado em $t4 como int no endereço apontado por $t2
				addi $v1, $v1, 1 # Incrementa o registrador de retorno do comprimento do vetor de retorno $v1 em 1
				addi $t2, $t2, 4 # Incrementa o ponteiro para $t2 para o próximo elemento vazio do vetor de retorno
				la $t4, ($zero) # Reseta o valor de $t4 para 0
				la $t6, ($zero) # reseta o contador $t6 para 0
				bgtz $t5, endStringToIntVector # Se o valor de $t5 for maior que 0 quer dizer que um valor ASCII de comando foi lido e portanto a função deve ser encerrada
				j loopStringToIntVector # Repete loopStringToIntVector até finalisar a função por erro ou pelo fim da String
		errorStringToIntVector:
			printString("Error: Caracter inválido lido. ")
			endProgram
		endStringToIntVector:
		
		jr $ra
		
	printVetorInt: #  Recebe o endereço do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e imprime todos os números do vetor
		# $t0 -> Ponteiro para o elemento atualmente avaliado
		# $t1 -> contador de números impressos
		# $a0 -> Valor a ser impresso
		ble $a2, $zero, endPrintVetorInt # Se o comprimento do vetor for menor ou igual a 0, a função é cancelada
		la $t1, ($zero) # Inicia o contador de números impressos $t1 com 0
		la $t0, ($a1) # Carrega em $t0 o endereço do primeiro elemento do vetor 
		loopPrintVetorInt:
			lw $a0, ($t0) # Carrega em $a0 o valor a ser impresso
			printInt
			newline
			addi $t0, $t0, 4 # Incrementa o ponteiro para o próximo elemento do vetor
			addi $t1, $t1, 1 # Incremenra o contador de números impressos
			blt $t1, $a2, loopPrintVetorInt # Enquanto o valor do contador de números impressos for menor que o comprimento do vetor repete o loopPrintVetorInt
		endPrintVetorInt:
		jr $ra
		
	somaVetor: # Recebe o endereço do prumeiro elemento do vetor de inteiros em $a1 e o comprimento dele em $a2 e retorna a soma dos valores dos elementos do vetor em $v1 
		# $t0 -> ponteiro para o vetor de entrada
		# $t1 -> contador de números já somados
		# $t2 -> armazena o valor do elemento do vetor atualmente apontado por $t0
		la $v1, ($zero) # Inicia $v1 com 0
		la $t0, ($a1) # Carrega o endereço do primeiro elemento do vetor de entrada no ponteiro $t0
		la $t1, ($zero) # Inicia o contador de números já somados com 0
		loopSomaVetor:
			bge $t1, $a2, fimLoopSomaVetor # Enquanto o comprimento do vetor for maior que o do contador $t1 repete o loopSomaVetor
			lw $t2, ($t0) # Carrega o registrador $t2 com o valor do elemento do vetor de entrada aponteado por $t0
			add $v1, $v1, $t2 # Soma o valor de $v1, com o valor do próximo elemento do vetor
			addi $t1, $t1, 1 # Incrementa o valor do contador $t1
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o próximo elemento do vetor de entrada
			j loopSomaVetor
		fimLoopSomaVetor:
		
		jr $ra
		
	multiplicaVetor: # Recebe o endereço do prumeiro elemento do vetor de inteiros em $a1 e o comprimento dele em $a2 e retorna o produto dos valores dos elementos do vetor em $v1 
		# $t0 -> ponteiro para o vetor de entrada
		# $t1 -> contador de números já multiplIcados
		# $t2 -> armazena o valor do elemento do vetor atualmente apontado por $t0
		li $v1, 1 # Inicia $v1 com 1
		la $t0, ($a1) # Carrega o endereço do primeiro elemento do vetor de entrada no ponteiro $t0
		la $t1, ($zero) # Inicia o contador de números já multiplicados com 0
		loopMultiplicaVetor:
			bge $t1, $a2, fimLoopMultiplicaVetor # Enquanto o comprimento do vetor for maior que o do contador $t1 repete o loopMultiplicaVetor
			lw $t2, ($t0) # Carrega o registrador $t2 com o valor do elemento do vetor de entrada aponteado por $t0
			mulo $v1, $v1, $t2 # Multiplica o valor de $v1, com o valor do próximo elemento do vetor
			addi $t1, $t1, 1 # Incrementa o valor do contador $t1
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o próximo elemento do vetor de entrada
			j loopMultiplicaVetor
		fimLoopMultiplicaVetor:
		
		jr $ra
		
	quantificaParesVetor:  # Recebe o endereço do prumeiro elemento do vetor em $a1 e o comprimento dele em $a2 e retorna a quantidade de elementos pares do vetor em $v1 
		# $t0 -> ponteiro para o vetor de entrada
		# $t1 -> contador de números já verificados
		# $t2 -> armazena o valor do elemento do vetor atualmente apontado por $t0
		# $t3 -> constante 2, para ser usada nas divisões
		# $t4 -> armazena o resto da divisão para verificar se o número atualmente apontado por $t0 é par ou ímpar
		la $v1, ($zero) # Inicia $v1 com 0
		la $t0, ($a1) # Carrega o endereço do primeiro elemento do vetor de entrada no ponteiro $t0
		la $t1, ($zero) # Inicia o contador de números já verificados com 0
		li $t3, 2 # Carrega 2 no registrador $t3
		loopQuantificaParesVetor:
			bge $t1, $a2, fimLoopQuantificaParesVetor # Enquanto o comprimento do vetor for maior que o do contador $t1 repete o fimLoopQuantificaParesVetor
			lw $t2, ($t0) # Carrega o registrador $t2 com o valor do elemento do vetor de entrada aponteado por $t0
			div $t2, $t3 # Divide o valor aramzenado em $t2 por 2
			mfhi $t4 # Salva o resto da divisão acima em $t4
			bne $t4, $zero, NotParQuantificaParesVetor # Se o resto da divisão 2 linhas acima não for zero o número não é par por isso deve ser pulada a linha abaixo
				addi $v1, $v1, 1 # Incrementa a quantidade de pares de $v1 em 1
			NotParQuantificaParesVetor:
			addi $t1, $t1, 1 # Incrementa o valor do contador $t1
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o próximo elemento do vetor de entrada
			j loopQuantificaParesVetor
		fimLoopQuantificaParesVetor:
		
		jr $ra
		
	quantificaImparesVetor: # Recebe o endereço do prumeiro elemento do vetor em $a1 e o comprimento dele em $a2 e retorna a quantidade de elementos ímpares do vetor em $v1 
		# $t0 -> ponteiro para o vetor de entrada
		# $t1 -> contador de números já verificados
		# $t2 -> armazena o valor do elemento do vetor atualmente apontado por $t0
		# $t3 -> constante 2, para ser usada nas divisões
		# $t4 -> armazena o resto da divisão para verificar se o número atualmente apontado por $t0 é par ou ímpar
		la $v1, ($zero) # Inicia $v1 com 0
		la $t0, ($a1) # Carrega o endereço do primeiro elemento do vetor de entrada no ponteiro $t0
		la $t1, ($zero) # Inicia o contador de números já verificados com 0
		li $t3, 2 # Carrega 2 no registrador $t3
		loopQuantificaImparesVetor:
			bge $t1, $a2, fimLoopQuantificaImparesVetor # Enquanto o comprimento do vetor for maior que o do contador $t1 repete o fimLoopQuantificaImparesVetor
			lw $t2, ($t0) # Carrega o registrador $t2 com o valor do elemento do vetor de entrada aponteado por $t0
			div $t2, $t3 # Divide o valor aramzenado em $t2 por 2
			mfhi $t4 # Salva o resto da divisão acima em $t4
			beq $t4, $zero, NotImparQuantificaImparesVetor # Se o resto da divisão 2 linhas acima for zero o número não é ímpar por isso deve ser pulada a linha abaixo
				addi $v1, $v1, 1 # Incrementa a quantidade de ímpares de $v1 em 1
			NotImparQuantificaImparesVetor:
			addi $t1, $t1, 1 # Incrementa o valor do contador $t1
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o próximo elemento do vetor de entrada
			j loopQuantificaImparesVetor
		fimLoopQuantificaImparesVetor:
		
		jr $ra
		
	encontraMaiorElementoVetor: # Recebe o endereço do prumeiro elemento do vetor em $a1 e o comprimento dele em $a2 e retorna o maior elementos do vetor em $v1 
		# $t0 -> ponteiro para o vetor de entrada
		# $t1 -> contador de números já verificados
		# $t2 -> armazena o valor do elemento do vetor atualmente apontado por $t0
		lw $v1, ($a1) # Inicia o maoir elemento do vetor $v1 com o primeiro elemento do vetor
		la $t0, ($a1) # Carrega o endereço do primeiro elemento do vetor de entrada no ponteiro $t0
		la $t1, ($zero) # Inicia o contador de números já verificados com 0
		loopEncontraMaiorElementoVetor:
			addi $t1, $t1, 1 # Incrementa o valor do contador $t1
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o próximo elemento do vetor de entrada
			bge $t1, $a2, fimLoopEncontraMaiorElementoVetor # Enquanto o comprimento do vetor for maior que o do contador $t1 repete o loopEncontraMaiorElementoVetor
			lw $t2, ($t0) # Carrega o registrador $t2 com o valor do elemento do vetor de entrada aponteado por $t0
			bge $v1, $t2, MantemMaoirEncontraMaiorElementoVetor # Se o valor armazenado em $v1 for maior ou igual ao armazenado em $t2, quer dizer que o maior ainda é o mesmo então pula a linha abaixo
				la $v1, ($t2) # Se o valor de $t1 for menor que o valor de $t2, o valor de $t2 é salvo como o novo maior valor 
			MantemMaoirEncontraMaiorElementoVetor:
			j loopEncontraMaiorElementoVetor
		fimLoopEncontraMaiorElementoVetor:
		
		jr $ra
	
	encontraMenorElementoVetor: # Recebe o endereço do prumeiro elemento do vetor em $a1 e o comprimento dele em $a2 e retorna o menor elementos do vetor em $v1 
		# $t0 -> ponteiro para o vetor de entrada
		# $t1 -> contador de números já verificados
		# $t2 -> armazena o valor do elemento do vetor atualmente apontado por $t0
		lw $v1, ($a1) # Inicia menor elemento do vetor $v1 com o primeiro elemento do vetor
		la $t0, ($a1) # Carrega o endereço do primeiro elemento do vetor de entrada no ponteiro $t0
		la $t1, ($zero) # Inicia o contador de números já verificados com 0
		loopEncontraMenorElementoVetor:
			addi $t1, $t1, 1 # Incrementa o valor do contador $t1
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o próximo elemento do vetor de entrada
			bge $t1, $a2, fimLoopEncontraMenorElementoVetor # Enquanto o comprimento do vetor for maior que o do contador $t1 repete o loopEncontraMenorElementoVetor
			lw $t2, ($t0) # Carrega o registrador $t2 com o valor do elemento do vetor de entrada aponteado por $t0
			ble $v1, $t2, MantemMenorEncontraMenorElementoVetor # Se o valor armazenado em $v1 for menor ou igual ao armazenado em $t2, quer dizer que o menor ainda é o mesmo então pula a linha abaixo
				la $v1, ($t2) # Se o valor de $t1 for menor que o valor de $t2, o valor de $t2 é salvo como o novo menor valor 
			MantemMenorEncontraMenorElementoVetor:
			j loopEncontraMenorElementoVetor
		fimLoopEncontraMenorElementoVetor:
		
		jr $ra
		
	ordenaVetorCrescente: # Recebe em $a1 o endereço do vetor e em $a2 o seu comprimento e ordena-o de forma crescente
		li $t0, 1
		j Wnext001        
		Wbody001:                
			sll $t4, $t0, 2    
			add $t4, $a1, $t4  
			lw $t3, 0($t4)
			addi $t1, $t0, -1
			j Wnext002       
		Wbody002:           
			sll  $t4, $t1, 2
			add $t4, $a1, $t4
			lw $t2, 0($t4)
			addi $t4, $t4, 4
			sw $t2, 0($t4)
			addi $t1, $t1, -1
		Wnext002:
			blt $t1, $zero, Wdone002
			sll  $t4, $t1, 2    
			add $t4, $a1, $t4    
			lw $t2, 0($t4)     
			bgt $t2, $t3, Wbody002
		Wdone002:                      
			add  $t4, $t1, 1    
			sll  $t4, $t4, 2 
			add $t4, $a1, $t4
			sw $t3, 0($t4)         
			addi $t0, $t0, 1
		Wnext001: 
			blt $t0,$a2, Wbody001
		 
	 	jr $ra
		
	printVetorIntReverso: #  Recebe o endereço do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e imprime todos os números do vetor em ordem reversa
		# $t0 -> Ponteiro para o elemento atualmente avaliado
		# $t1 -> contador de números impressos
		# $t2 -> registrador auxiliar no processo de criar o ponteiro para o último elemento
		# $a0 -> Valor a ser impresso
		ble $a2, $zero, endPrintVetorIntReverso # Se o comprimento do vetor for menor ou igual a 0, a função é cancelada
		la $t1, ($zero) # Inicia o contador de números impressos $t1 com 0
		subi $t2, $a2, 1 # Carrega $t2 com o comprimento do vetor de entrada -1
		mulo $t2, $t2, 4 # Multiplica o comprimento do vetor de entrada por 4 para obter como resultado o espaço ocupado pelo vetor e salva em $t2
		add $t0, $a1, $t2 # Soma o valor do espaço de memória ocupado pelo vetor com o endereço do primeiro elemento para obter o endereço do último elemento e salva no ponteiro $t0
		loopPrintVetorIntReverso:
			lw $a0, ($t0) # Carrega em $a0 o valor a ser impresso
			printInt
			newline
			subi $t0, $t0, 4 # Decrementa o ponteiro para o elemento anterior do vetor
			addi $t1, $t1, 1 # Incremenra o contador de números impressos
			blt $t1, $a2, loopPrintVetorIntReverso # Enquanto o valor do contador de números impressos for menor que o comprimento do vetor repete o loopPrintVetorInt
		endPrintVetorIntReverso:
		jr $ra
