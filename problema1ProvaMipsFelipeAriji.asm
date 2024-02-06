.macro endProgram # encerra o programa
	li $v0, 10
	syscall
.end_macro
	
.macro printInt (%int) # salva em $a0 o valor fornecido no par�metro como inteiro e imprime-o
	la $a0, (%int)
	li $v0, 1 # c�digo de impress�o de inteiro
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

.macro mallocInt(%intQuantity) # Aloca dinamicamente o espa�o para a quantidade de inteiros passada no par�metro e salva o endere�o alocado em $v0 
	mul  $a0, %intQuantity, 4 # Salva em $a0 a quantidade de espa�o de mem�ria necess�rio para alocar a quantidade de int inserida como par�metro
	li $v0, 9
	syscall
.end_macro
	
.text

	Main:
		printString("Insira a quantidade elementos do vetor a ser avaliado: ") # Imprime a mensagem pedindo o tamanho do vetor a ser inserido
		readInt # L� o inteiro representando inserido como resposta e armazena em $v0
		la $a2, ($v0) # Carrega o valor lido como par�metro do comprimento do vetor para todas as fun��es
		mallocInt($a2) # Aloca din�micamente o espa�o necess�rio para armazenar a quantidade de inteiros inserida pelo usu�rio
		la $a1, ($v0) # Salva o endere�o alocado din�micamente em $a1, para ser passado como par�metro para todas as fun��es
		jal lerNInteiros # Vai para a fun��o lerNInteiros e salva em $ra o endere�o dessa linha de chamada
		newline # Quebra de linha
		
		printString("O vetor inserido foi: ") # Imprime a mensagem para come�ar a apresentar o vetor inserido pelo usu�rio
		newline # Quebra de linha
		jal printVetorInt # Vai para a fun��o printVetorInt e salva em $ra o endere�o dessa linha de chamada
		newline # Quebra de linha
		
		jal proc_ord # Vai para a fun��o proc_ord e salva em $ra o endere�o dessa linha de chamada
		printString("O vetor ordenado de forma crescente toma a sequ�ncia: ") # Imprime a mensagem para come�ar a apresentar de forma ordenada o vetor inserido pelo usu�rio 
		newline # Quebra de linha
		jal printVetorInt # Vai para a fun��o printVetorInt e salva em $ra o endere�o dessa linha de chamada
		newline # Quebra de linha
		
		jal proc_maior_soma # Vai para a fun��o proc_maior_soma e salva em $ra o endere�o dessa linha de chamada
		printString("O n�mero de elementos maiores que a soma dos N elementos lidos: ") # Imprime a mensagem para mostrar um dado
		printInt($v1) # Imprime o retorno da fun��o proc_maior_soma
		newline # Quebra de linha
		
		jal  proc_num_�mpar # Vai para a fun��o proc_num_�mpar e salva em $ra o endere�o dessa linha de chamada
		printString("O vetor cont�m ") # Imprime a mensagem para mostrar a quantidade de �mpares
		printInt($v1) # Imprime a quantidade de n�meros �mpares do vetor
		beq $v1, 1, umImpar # Se existir 1 �mpar pula para o bloco umImpar para imprimir uma mensagem com concord�ncia num�rica 
			printString(" elementos �mpares.") # Imprime o final da mensagem da quantidade de �mpares
			bgtz, $v1, maisDeUmImpar # Se houver mais de 1 �mpar pula a linha abaixo e segue o c�digo normalmente
			j NenhumImpar # Se n�o, n�o existe �mpares nesse vetor, sendo imposs�vel aplicar a fun��o proc_prod_pos, ent�o pula para o label NenhumImpar
		umImpar: # Se existir 1 �mpar pula para esse bloco
			printString(" elemento �mpar") # Imprime o final da mensagem da quantidade de �mpares para somente 1 �mpar 
		maisDeUmImpar: # Se houver mais de 1 �mpar pula para esse label
		newline # Quebra de linha
		
		jal  quantificaParesVetor # Vai para a fun��o quantificaParesVetor e salva em $ra o endere�o dessa linha de chamada
		beqz $v1, NenhumPar # Se o retorno da fun��o anterior for 0, n�o existe par nesse vetor ent�o deve ir para o label NenhumPar
		
		printString("O produto do menor elemento �mpar com o maior par desse vetor �: ") # Imprime mensagem para dar o retorno da fun��o proc_prod_pos
		jal proc_prod_pos # Vai para a fun��o proc_prod_pos e salva em $ra o endere�o dessa linha de chamada
		printInt($v1) # Imprime o retorno da fun��o proc_prod_pos
		endProgram # Encerra o programa
		
		NenhumImpar: # Label para caso n�o houver �mpar, pular para ele cancela a fun��o proc_prod_pos
			newline # Quebra de linha
			printString("n�o h� elemento �mpar.") # Imprime mensagem dizendo que n�o h� elementos �mpares no vetor inserido pelo usu�rio
			endProgram # Encerra o programa
			
		NenhumPar: # Label para caso n�o houver par, pular para ele cancela a fun��o proc_prod_pos
			printString("n�o h� elemento par.") # Imprime mensagem dizendo que n�o h� elementos pares no vetor inserido pelo usu�rio
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
		
	quantificaParesVetor:  # Recebe o endere�o do prumeiro elemento do vetor em $a1 e o comprimento dele em $a2 e retorna a quantidade de elementos pares do vetor em $v1 
		# $t0 -> ponteiro para o vetor de entrada
		# $t1 -> contador de n�meros j� verificados
		# $t2 -> armazena o valor do elemento do vetor atualmente apontado por $t0
		# $t3 -> constante 2, para ser usada nas divis�es
		# $t4 -> armazena o resto da divis�o para verificar se o n�mero atualmente apontado por $t0 � par ou �mpar
		la $v1, ($zero) # Inicia o registrador de retorno da quantidade de pares $v1 com 0
		la $t0, ($a1) # Carrega o endere�o do primeiro elemento do vetor de entrada no ponteiro $t0
		la $t1, ($zero) # Inicia o contador de n�meros j� verificados $t1 com 0
		li $t3, 2 # Carrega 2 no registrador $t3
		loopQuantificaParesVetor:
			bge $t1, $a2, fimLoopQuantificaParesVetor # Quando o comprimento do vetor for maior que o do contador $t1 vai para o fimLoopQuantificaParesVetor
			lw $t2, ($t0) # Carrega o registrador $t2 com o valor do elemento do vetor de entrada aponteado por $t0
			div $t2, $t3 # Divide o valor aramzenado em $t2 por 2
			mfhi $t4 # Salva o resto da divis�o acima em $t4
			bne $t4, $zero, NotParQuantificaParesVetor # Se o resto da divis�o 2 linhas acima n�o for zero o n�mero n�o � par por isso deve ser pulada a linha abaixo
				addi $v1, $v1, 1 # Incrementa a quantidade de pares de $v1 em 1
			NotParQuantificaParesVetor: # Se $t2 n�o for �mpar pula a linha acima direto para esse label
			addi $t1, $t1, 1 # Incrementa o valor do contador $t1
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o pr�ximo elemento do vetor de entrada
			j loopQuantificaParesVetor # Repete o loopQuantificaParesVetor 
		fimLoopQuantificaParesVetor:
		
		jr $ra # retorna para o local de chamada da fun��o
		
	proc_num_�mpar: # Recebe o endere�o do prumeiro elemento do vetor em $a1 e o comprimento dele em $a2 e retorna a quantidade de elementos �mpares do vetor em $v1 
		# $t0 -> ponteiro para o vetor de entrada
		# $t1 -> contador de n�meros j� verificados
		# $t2 -> armazena o valor do elemento do vetor atualmente apontado por $t0
		# $t3 -> constante 2, para ser usada nas divis�es
		# $t4 -> armazena o resto da divis�o para verificar se o n�mero atualmente apontado por $t0 � par ou �mpar
		la $v1, ($zero) # Inicia o registrador de retorno da quantidade de �mpares $v1 com 0
		la $t0, ($a1) # Carrega o endere�o do primeiro elemento do vetor de entrada no ponteiro $t0
		la $t1, ($zero) # Inicia o contador de n�meros j� verificados $t1 com 0
		li $t3, 2 # Carrega 2 no registrador $t3
		loop_proc_num_�mpar:
			bge $t1, $a2, fim_loop_proc_num_�mpar # Se o comprimento do vetor for maior que o do contador $t1 vai para fim_loop_proc_num_�mpar
			lw $t2, ($t0) # Carrega o registrador $t2 com o valor do elemento do vetor de entrada aponteado por $t0
			div $t2, $t3 # Divide o valor aramzenado em $t2 por 2
			mfhi $t4 # Salva o resto da divis�o acima em $t4
			beq $t4, $zero, Not_impar_proc_num_�mpar # Se o resto da divis�o 2 linhas acima for zero o n�mero n�o � �mpar por isso deve ser pulada a linha abaixo
				addi $v1, $v1, 1 # Incrementa a quantidade de �mpares de $v1 em 1
			Not_impar_proc_num_�mpar: # Se $t2 n�o for �mpar pula a linha acima direto para esse label
			addi $t1, $t1, 1 # Incrementa o valor do contador $t1
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o pr�ximo elemento do vetor de entrada
			j loop_proc_num_�mpar # Repete o loop_proc_num_�mpar
		fim_loop_proc_num_�mpar:
		
		jr $ra # retorna para o local de chamada da fun��o
		
	proc_maior_soma: # Recebe em $a1 o endere�o de um vetor e em $a2 seu comprimento e retorna em $v1 a quantidade de n�meros com valor maior que o da quantidade de n�meros
		# $t0 -> ponteiro para o vetor de entrada
		# $t1 -> valor do elemento apontado atualmente pelo ponteiro $t0
		# $t2 -> contador de elementos analisados do vetor de entrada
		la $v1, ($zero) # Inicia o registrador de retorno da quantidade de n�meros maiores que o valor do comprimento do vetor de entrada $v1 com 0
		la $t0, ($a1) # Carrega o endere�o do primeiro elemento do vetor de entrada no ponteiro $t0
		la $t2, ($zero) # Inicia o contador de n�meros j� verificados $t2 com 0
		loop_proc_maior_soma:
			lw $t1, ($t0) # Carrega em $t1 o valor do elemento atualmente apontado pelo ponteiro $t0
			ble $t1, $a2, menor_que_comprimento_proc_maior_soma # Se o valor armazenado em $t1 for menor que o comprimento do vetor de entrada pula o bloco abaixo indo para o label menor_que_comprimento_proc_maior_soma
				addi $v1, $v1, 1 # Incrementa em 1 o registrador de retorno da quantidade de n�meros maiores que o valor do comprimento do vetor de entrada $v1
			menor_que_comprimento_proc_maior_soma: # Label usado para pular a linha acima se o valor de $t1 for menor que o de $a2
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o pr�ximo elemento do vetor de entrada
			addi $t2, $t2, 1 # Incrementa o contador de elementos analisados do vetor de entrada $t2 em 1
			blt $t2, $a2, loop_proc_maior_soma # Enquanto a quantidade de elementos analisados $t2, for menor que o comprimento do vetor repete o loop_proc_maior_soma
		jr $ra # retorna para o local de chamada da fun��o
		
	proc_prod_pos: # Recebe em $a1 o endere�o do vetor ordenado de forma crescente e em $a2 o seu comprimento, retorna em $v1 o produto do menor �mpar com o maior par
		# $t0 -> ponteiro para o vetor de entrada
		# $t1 -> registrador que armazena o valor do elemento atualmente aponteado pelo ponteiro $t0
		# $t2 -> registrador do maior elemento par do vetor de entrada
		# $t3 -> registrador do menor elemento �mpar do vetor de entrada
		# $t4 -> contador da quantidade de elementos avaliados
		# $t5 -> constante 2, utilizada na divis�o para verificar se o n�mero � par ou �mpar
		# $t6 -> registrador que armazena o resto da divis�o para comparar com 0 e verificar se o n�mero � par ou �mpar
		# $t7 -> registrador booleano que armazena 0 se n�o tiver sido registrado nenhum �mpar em $t3 e 1 caso contr�rio 
		la $t0, ($a1) # Carrega o endere�o do primeiro elemento do vetor de entrada no ponteiro $t0
		la $t4, ($zero) # Inicia com 0 o contador da quantide de elementos avaliados $t4
		li $t5, 2 # Carrega $t5 com a constante 2
		la $t7, ($zero) # Inicia com 0 o contador da quantidade de �mpares analisados no vetor $t7
		loop_proc_prod_pos:
			addi $t4, $t4, 1 # Incrementa em 1 o contador da quantidade de elementos avaliados $t4
			lw $t1, ($t0) # Carrega em $t1 o valor do elemento atualmente apontado pelo ponteiro $t0
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o pr�ximo elemento do vetor de entrada
			div $t1, $t5 # Divide $t1 por 2
			mfhi $t6 #  Armazena o resto da divis�o acima em $t6
			beqz $t6, maior_par_proc_prod_pos # Se o resto da divis�o acima for igual a 0 o n�mero em $t1 � par, portanto vai para o bloco maior_par_proc_prod_pos
				bgtz $t7, impar_maior_proc_prod_pos # Se $t7 for maior que 0 quer dizer que esse n�o � o primeiro �mpar avaliado e como esse � um vetor crescente ele n�o � o menor, ent�o n�o deve ser registrado em $t3
					la $t3, ($t1) # Armazena o primeiro valor �mpar do vetor em $t3 como o menor �mpar, pois em um vetor crescente o primeiro �mpar � o menor deles
					addi $t7, $t7, 1 # Adiciona 1 no registrador $t7 para registrar que o menor �mpar j� foi registrado
				impar_maior_proc_prod_pos: # Caso n�o seja o menor �mpar da sequ�ncia, ou seja, o primeiro do vetor, pula para esse label
				blt $t4, $a2, loop_proc_prod_pos # Enquanto a quantidade de n�meros avaliados, $t4, for menor que a quantidade de n�meros do vetor repete o loop_proc_prod_pos
			maior_par_proc_prod_pos: # Vem para esse bloco caso o n�mero armazenado em $t1 seja par
				la $t2, ($t1) # Armazena em $t2 o valor do n�mero par armazenado em $t1, pois o n�mero par maior em um vetor crescente � o mais pr�ximo do final
				blt $t4, $a2, loop_proc_prod_pos # Enquanto a quantidade de n�meros avaliados, $t4, for menor que a quantidade de n�meros do vetor repete o loop_proc_prod_pos
		mulo $v1, $t2, $t3 # Multiplica o maior par, armazenado em $t2, e o menor �mpar, armazenado em $t3, e salva o resultado em $v1 
		jr $ra # retorna para o local de chamada da fun��o
		
	proc_ord: # Recebe em $a1 o endere�o do vetor e em $a2 o seu comprimento e ordena-o de forma crescente
		li $t0, 1 # Inicia o contador com 1
		j Wnext001# pula para o bloco de verifica��o do fim da fun��o
		Wbody001: # Come�o da fun��o, onde reinicia o loop, Inicia contadores e ponteiros               
			sll $t4, $t0, 2    
			add $t4, $a1, $t4  
			lw $t3, 0($t4)
			addi $t1, $t0, -1
			j Wnext002 # Vai para Wnext002
		Wbody002: # Segunda parte da fun��o
			sll  $t4, $t1, 2
			add $t4, $a1, $t4
			lw $t2, 0($t4)
			addi $t4, $t4, 4
			sw $t2, 0($t4)
			addi $t1, $t1, -1
		Wnext002: # Parte que deve ser repetida ap�s os dois Wbody
			blt $t1, $zero, Wdone002
			sll  $t4, $t1, 2    
			add $t4, $a1, $t4    
			lw $t2, 0($t4)     
			bgt $t2, $t3, Wbody002
		Wdone002: # Encerramento da fun��o, incrementando contadores e ponteiros                 
			add  $t4, $t1, 1    
			sll  $t4, $t4, 2 
			add $t4, $a1, $t4
			sw $t3, 0($t4)         
			addi $t0, $t0, 1
		Wnext001: # Verifica se o contador de repeti��es $t0 possui valor menor que o comprimento do vetor, caso sim repete a fun��o a partir do label Wbody001, se n�o encerra a fun��o
			blt $t0,$a2, Wbody001
		 
	 	jr $ra # retorna para o local de chamada da fun��o
