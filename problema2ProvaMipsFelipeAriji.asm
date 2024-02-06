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
	
.macro printInt # imprime o inteiro do registrador $a0
	li $v0, 1
	syscall
.end_macro

.macro newline # quebra linha
	li $a0, 10 # C�digo ASCII para ("\n")	
	li $v0, 11 # C�digo de impress�o de caractere
	syscall
.end_macro
	
.macro readInt # l� um inteiro inserido pelo usu�rio e salva em $v0
	li $v0, 5
	syscall
.end_macro

.data
	
	V: .space 80 # Vetor de entrada para receber os 20 inteiros do usu�rio
	Y: .space 80 # Vetor de retorno da fun��o para armazenar no m�ximo 20 inteiros, caso todos elementos de V sejam primos
	
.text
	
	Main:
		
		printString("Preencha o vetor V: ") # Imprime a mensagem que pede ao usu�rio para preencher o vetor V
		newline # Quebra de linha
		la $a1, V # Carrega o endere�o do primeiro elemento do vetor V como par�metro para as fun��es lerNInteiros e criaSubvetorDePrimos
		la $a2, 20 # Carrega 20 como par�metro do comprimento do vetor a ser lido para as fun��es lerNInteiros e criaSubvetorDePrimos
		jal lerNInteiros # Vai para a fun��o lerNInteiros e salva em $ra o endere�o dessa linha de chamada
		
		la $a3, Y # Carrega o endere�o do primeiro elemento do vetor Y como par�metro para a fun��o criaSubvetorDePrimos
		jal criaSubvetorDePrimos # Vai para a fun��o criaSubvetorDePrimos e salva em $ra o endere�o dessa linha de chamada
		
		beqz $v1, nenhumPrimo # Se o retorno da quantidade de n�meros primos for igual a 0, n�o tem nenhum primo, ent�o pula para o bloco nenhumPrimo
			la $a1, Y # Se n�o carrega o endere�o do primeiro elemento do vetor Y como par�metro para a fun��o printVetorInt
			la $a2, ($v1) # Carrega a quantidade de primos do vetor V, armazenada em $v1 como par�metro do comprimento do vetor para a fun��o printVetorInt
			jal printVetorInt # Vai para a fun��o printVetorInt e salva em $ra o endere�o dessa linha de chamada
			endProgram # Encerra o programa
			
		nenhumPrimo: # Executa esse bloco somente se n�o houver nenhum primo no vetor de entrada V
			printString("N�o h� elementos primos no vetor") # Imprime a mensagem para nenhum primo no vetor de entrada V
			endProgram # Encerra o programa
		
	lerNInteiros: # Recebe o endere�o do primeiro elemento do vetor de entrada em $a1 e l� a quantidade de n�meros inteiros positivos do usu�rio equivalente ao valor recebido em $a2, salvando-os no vetor recebido
		# $t0 -> ponteiro para o pr�ximo espa�o vazio do vetor
		# $t1 -> contador de valores recebidos pelo usu�rio
		la $t1, ($zero) # Inicia com zero o contador da quantidade de n�meros lidos $t1
		la $t0, ($a1) # Aponta o ponteiro $t0 para o primeiro espa�o livre do vetor
		loopLerNInteiros:
			printString("Insira o pr�ximo n�mero a ser inserido no vetor: ") # Imprime a mensagem que pede para o usu�rio inserir o pr�ximo n�mero do vetor
			readInt # L� o inteiro inserido pelo usu�rio e salva em $v0
			addi $t1, $t1, 1 # incrementa a quantidade de n n�meros inteiros lidos em $t1
			sw $v0, ($t0) # Armazena o valor recebido do usu�rio, armazenado em $v0, no pr�ximo espa�o vazio do vetor apontado pelo ponteiro $t0
			addi $t0, $t0, 4 # incrementa o ponteiro $t0 para o pr�ximo espa�o vazio do vetor
			blt $t1, $a2,  loopLerNInteiros # Enquanto o n�mero de elementos lidos for menor do que o tamanho do vetor de entrada repete o loopLerNInteiros
		jr $ra # retorna para o local de chamada da fun��o
		
	printVetorInt: #  Recebe o endere�o do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e imprime todos os n�meros do vetor
		# $t0 -> ponteiro para o vetor de entrada
		# $t1 -> contador de n�meros impressos
		# $a0 -> valor a ser impresso
		ble $a2, $zero, endPrintVetorInt # Se o comprimento do vetor for menor ou igual a 0, a fun��o � cancelada, pulando para o bloco endPrintVetorInt
		la $t1, ($zero) # Inicia o contador de n�meros impressos $t1 com 0
		la $t0, ($a1) # Carrega em $t0 o endere�o do primeiro elemento do vetor 
		loopPrintVetorInt:
			lw $a0, ($t0) # Carrega em $a0 o valor a ser impresso
			printInt # Imprime o inteiro carregado
			newline # Quebra de linha
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o pr�ximo elemento do vetor
			addi $t1, $t1, 1 # Incremenra o contador $t1 de n�meros impressos
			blt $t1, $a2, loopPrintVetorInt # Enquanto o valor do contador de n�meros impressos $t1 for menor que o comprimento do vetor repete o loopPrintVetorInt
		endPrintVetorInt:
		jr $ra # retorna para o local de chamada da fun��o
		
	criaSubvetorDePrimos:# Recebe o endere�o do primeiro elemento do vetor em $a1 e o comprimento dele em $a2 , para retornar em $v1 a quantidade de n�meros primos desse vetor e criar um subvetor apenas com os elementos primos do de entrada no endere�o recebido em $a3
		# $t0 -> ponteiro para o vetor de entrada passado em $a1
		# $t1 -> registrador do valor do elemento atualmente apontado pelo ponteiro $t0
		# $t2 -> registrador do valor usado para as compara��es dos blocos verifica
		# $t3 -> divisor dos blocos verificaPar e verificaComposto
		# $t4 -> limitante de divisor do bloco verificaComposto
		# $t5 -> quantidade de elementos analisados
		# $t6 -> ponteiro para o pr�ximo espa�o vazio do vetor de retorno passado em $a3
		# $t3 -> contador de elementos do vetor de entrada analisados
		la $t0, ($a1) # Carrega o endere�o do primeiro elemento do vetor de entrada no ponteiro $t0
		la $t6, ($a3) # Carrega o endere�o do primeiro elemento do vetor de retorno no ponteiro $t6
		la $t5, ($zero) # Inicia com zero o contador da quantidade de n�meros do vetor de entrada analisados $t3
		la $v1, ($zero) # Incia o registrador de retorno da quantidade de n�meros primos $v1 com zero
		loopCriaSubvetorDePrimos:
			lw $t1, ($t0) # Carrega o valor do elemento analisado atualmente
			verificaMenor2: # Bloco que verifica de o n�mero atualmente salvo em $t1 � menor que 2, pois qualquer n�mero menor que 2 n�o � primo
				subi $t2, $t1, 2 # Subtrai o valor de $t1 por 2, e armazena em $t2
				bltz $t2, isNotPrimeNumber # Se o resultado da subtra��o acima for menor que 0 significa que o valor de $t1 � menor que 2, portanto n�o � primo, ent�o deve ir para o bloco isNotPrimeNumber
			verifica2e3: # Bloco que verifica se o n�mero atualmente salvo em $t1 � 2 ou 3, pois 2 e 3 s�o primos
				subi $t2, $t1, 4 # Subtrai o valor de $t1 por 4 e armazena em $t2
				bltz $t2, isPrimeNumber # Se o resultado da subtra��o acima for menor que 0 significa que o valor de $t1 � menor que 4 e como j� passou pelo bloco verificaMenor2 � maior que 2, podendo ser apenas os primos 2 e 3, ent�o deve ir para o bloco isPrimeNumber
			verificaPar: # Bloco que verifica se $t1 � par, pois qualquer n�mero par maior que 2 n�o � primo
				li $t3, 2 # Carrega 2 no registrador do divisor
				div $t1, $t3 # Divide o valor de $t1 por 2 
				mfhi $t2 # Armazena o resto da divis�o acima em $t2
				beq $t2, $zero, isNotPrimeNumber # Se o resto da divis�o acima for 0 significa que o valor de $t1 � par e como j� passou pelo bloco verifica2e3, maior que 2, portanto n�o pe primo, ent�o deve ir para o bloco isNotPrimeNumber
			verificaComposto: # Bloco que verifica se o n�mero atualmente salvo em $t1 � composto, pois qualquer n�mero composto n�o � primo
				li $t3, 3 # Carrega o divisor com 3
				div $t4, $t1, 2 # Carrega $t4 com a metade do n�mero de $t1 como o limitante de divisor
				loopVerificaComposto: 
					div $t1, $t3 # divide o valor de $t1 pelo divisor
					mfhi $t2 # Carrega o resto da divis�o em $t2
					beq $t2, $zero, isNotPrimeNumber # Se o resto da divis�o acima for 0 o n�mero n�o � primo, ent�o vai para o bloco isNotPrimeNumber
					addi $t3, $t3,  2 # Incrementa o divisor $t3 para o pr�ximo divisor �mpar
					blt $t3, $t4, loopVerificaComposto # Enquanto o divisor $t3 for menor que o limitante dele $t4 repete o loop loopVerificaComposto
					# Se depois de todos os testes, o n�mero n�o possuir nenhum divisor al�m dele mesmo e 1 ele � primo 
			isPrimeNumber: # Se o n�mero armazenado em $t1 for primo, passa por esse bloco 
				sw $t1, ($t6) # Armazena o valor primo de $t1 no pr�ximo espa�o vazio do vetor de retorno
				addi $t6, $t6, 4 # Incrementa o ponteiro $t6 para o pr�ximo elemento do vetor de retorno
				addi $v1, $v1, 1 # Incrementa o registrador de retorno da quantidade de n�meros $v1 em 1 
				isNotPrimeNumber: # Se o n�mero armazenado em $t1 n�o for primo, vem direto para esse bloco 
					addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o pr�ximo elemento do vetor
					addi $t5, $t5, 1 # Incrementa o contador $t5 de elementos analisados 
					blt $t5, $a2, loopCriaSubvetorDePrimos # Enquanto a quantidade de elementos analisados for menor do que a quantidade de n�meros do vetor repete o loopCriaSubvetorDePrimos
						
		jr $ra # retorna para o local de chamada da fun��o
