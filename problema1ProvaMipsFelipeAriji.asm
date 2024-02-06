.macro endProgram # encerra o programa
	li $v0, 10
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
	
.macro printInt # imprime o inteiro do registrador $a0
	li $v0, 1
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

.macro mallocInt(%intQuantity) # Aloca dinamicamente o espaço para a quantidade de inteiros passada no parâmetro e salva o endereço alocado em $v0 
	mul  $a0, %intQuantity, 4 # Salva em $a0 a quantidade de espaço de memória necessário para alocar a quantidade de int inserida como parâmetro
	li $v0, 9
	syscall
.end_macro
	
.text

	Main:
		printString("Insira a quantidade elementos do vetor a ser avaliado: ") # Imprime a mensagem pedindo o tamanho do vetor a ser inserido
		readInt # Lê o inteiro representando inserido como resposta e armazena em $v0
		la $a2, ($v0) # Carrega o valor lido como parâmetro do comprimento do vetor para todas as funções
		mallocInt($a2) # Aloca dinâmicamente o espaço necessário para armazenar a quantidade de inteiros inserida pelo usuário
		la $a1, ($v0) # Salva o endereço alocado dinâmicamente em $a1, para ser passado como parâmetro para todas as funções
		jal lerNInteiros # Vai para a função lerNInteiros e salva em $ra o endereço dessa linha de chamada
		newline # Quebra de linha
		
		printString("O vetor inserido foi: ") # Imprime a mensagem para começar a apresentar o vetor inserido pelo usuário
		newline # Quebra de linha
		jal printVetorInt # Vai para a função printVetorInt e salva em $ra o endereço dessa linha de chamada
		newline # Quebra de linha
		
		jal proc_ord # Vai para a função proc_ord e salva em $ra o endereço dessa linha de chamada
		printString("O vetor ordenado de forma crescente toma a sequência: ") # Imprime a mensagem para começar a apresentar de forma ordenada o vetor inserido pelo usuário 
		newline # Quebra de linha
		jal printVetorInt # Vai para a função printVetorInt e salva em $ra o endereço dessa linha de chamada
		newline # Quebra de linha
		
		jal proc_maior_soma # Vai para a função proc_maior_soma e salva em $ra o endereço dessa linha de chamada
		printString("O número de elementos maiores que a soma dos N elementos lidos: ") # Imprime a mensagem para mostrar um dado
		printInt($v1) # Imprime o retorno da função proc_maior_soma
		newline # Quebra de linha
		
		jal  proc_num_ímpar # Vai para a função proc_num_ímpar e salva em $ra o endereço dessa linha de chamada
		printString("O vetor contêm ") # Imprime a mensagem para mostrar a quantidade de ímpares
		printInt($v1) # Imprime a quantidade de números ímpares do vetor
		beq $v1, 1, umImpar # Se existir 1 ímpar pula para o bloco umImpar para imprimir uma mensagem com concordância numérica 
			printString(" elementos ímpares.") # Imprime o final da mensagem da quantidade de ímpares
			bgtz, $v1, maisDeUmImpar # Se houver mais de 1 ímpar pula a linha abaixo e segue o código normalmente
			j NenhumImpar # Se não, não existe ímpares nesse vetor, sendo impossível aplicar a função proc_prod_pos, então pula para o label NenhumImpar
		umImpar: # Se existir 1 ímpar pula para esse bloco
			printString(" elemento ímpar") # Imprime o final da mensagem da quantidade de ímpares para somente 1 ímpar 
		maisDeUmImpar: # Se houver mais de 1 ímpar pula para esse label
		newline # Quebra de linha
		
		jal  quantificaParesVetor # Vai para a função quantificaParesVetor e salva em $ra o endereço dessa linha de chamada
		beqz $v1, NenhumPar # Se o retorno da função anterior for 0, não existe par nesse vetor então deve ir para o label NenhumPar
		
		printString("O produto do menor elemento ímpar com o maior par desse vetor é: ") # Imprime mensagem para dar o retorno da função proc_prod_pos
		jal proc_prod_pos # Vai para a função proc_prod_pos e salva em $ra o endereço dessa linha de chamada
		printInt($v1) # Imprime o retorno da função proc_prod_pos
		endProgram # Encerra o programa
		
		NenhumImpar: # Label para caso não houver ímpar, pular para ele cancela a função proc_prod_pos
			newline # Quebra de linha
			printString("não há elemento ímpar.") # Imprime mensagem dizendo que não há elementos ímpares no vetor inserido pelo usuário
			endProgram # Encerra o programa
			
		NenhumPar: # Label para caso não houver par, pular para ele cancela a função proc_prod_pos
			printString("não há elemento par.") # Imprime mensagem dizendo que não há elementos pares no vetor inserido pelo usuário
			endProgram # Encerra o programa
		
	lerNInteiros: # Recebe o endereço do primeiro elemento do vetor de entrada em $a1 e lê a quantidade de números inteiros positivos do usuário equivalente ao valor recebido em $a2, salvando-os no vetor recebido
		# $t0 -> ponteiro para o próximo espaço vazio do vetor
		# $t1 -> contador de valores recebidos pelo usuário
		la $t1, ($zero) # Inicia com zero o contador da quantidade de números lidos $t1
		la $t0, ($a1) # Aponta o ponteiro $t0 para o primeiro espaço livre do vetor
		loopLerNInteiros:
			printString("Insira o próximo número a ser inserido no vetor: ") # Imprime a mensagem que pede para o usuário inserir o próximo número do vetor
			readInt # Lê o inteiro inserido pelo usuário e salva em $v0
			addi $t1, $t1, 1 # incrementa a quantidade de n números inteiros lidos em $t1
			sw $v0, ($t0) # Armazena o valor recebido do usuário, armazenado em $v0, no próximo espaço vazio do vetor apontado pelo ponteiro $t0
			addi $t0, $t0, 4 # incrementa o ponteiro $t0 para o próximo espaço vazio do vetor
			blt $t1, $a2,  loopLerNInteiros # Enquanto o número de elementos lidos for menor do que o tamanho do vetor de entrada repete o loopLerNInteiros
		jr $ra # retorna para o local de chamada da função
		
	printVetorInt: #  Recebe o endereço do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e imprime todos os números do vetor
		# $t0 -> ponteiro para o vetor de entrada
		# $t1 -> contador de números impressos
		# $a0 -> valor a ser impresso
		ble $a2, $zero, endPrintVetorInt # Se o comprimento do vetor for menor ou igual a 0, a função é cancelada, pulando para o bloco endPrintVetorInt
		la $t1, ($zero) # Inicia o contador de números impressos $t1 com 0
		la $t0, ($a1) # Carrega em $t0 o endereço do primeiro elemento do vetor 
		loopPrintVetorInt:
			lw $a0, ($t0) # Carrega em $a0 o valor a ser impresso
			printInt # Imprime o inteiro carregado
			newline # Quebra de linha
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o próximo elemento do vetor
			addi $t1, $t1, 1 # Incremenra o contador $t1 de números impressos
			blt $t1, $a2, loopPrintVetorInt # Enquanto o valor do contador de números impressos $t1 for menor que o comprimento do vetor repete o loopPrintVetorInt
		endPrintVetorInt:
		jr $ra # retorna para o local de chamada da função
		
	quantificaParesVetor:  # Recebe o endereço do prumeiro elemento do vetor em $a1 e o comprimento dele em $a2 e retorna a quantidade de elementos pares do vetor em $v1 
		# $t0 -> ponteiro para o vetor de entrada
		# $t1 -> contador de números já verificados
		# $t2 -> armazena o valor do elemento do vetor atualmente apontado por $t0
		# $t3 -> constante 2, para ser usada nas divisões
		# $t4 -> armazena o resto da divisão para verificar se o número atualmente apontado por $t0 é par ou ímpar
		la $v1, ($zero) # Inicia o registrador de retorno da quantidade de pares $v1 com 0
		la $t0, ($a1) # Carrega o endereço do primeiro elemento do vetor de entrada no ponteiro $t0
		la $t1, ($zero) # Inicia o contador de números já verificados $t1 com 0
		li $t3, 2 # Carrega 2 no registrador $t3
		loopQuantificaParesVetor:
			bge $t1, $a2, fimLoopQuantificaParesVetor # Quando o comprimento do vetor for maior que o do contador $t1 vai para o fimLoopQuantificaParesVetor
			lw $t2, ($t0) # Carrega o registrador $t2 com o valor do elemento do vetor de entrada aponteado por $t0
			div $t2, $t3 # Divide o valor aramzenado em $t2 por 2
			mfhi $t4 # Salva o resto da divisão acima em $t4
			bne $t4, $zero, NotParQuantificaParesVetor # Se o resto da divisão 2 linhas acima não for zero o número não é par por isso deve ser pulada a linha abaixo
				addi $v1, $v1, 1 # Incrementa a quantidade de pares de $v1 em 1
			NotParQuantificaParesVetor: # Se $t2 não for ímpar pula a linha acima direto para esse label
			addi $t1, $t1, 1 # Incrementa o valor do contador $t1
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o próximo elemento do vetor de entrada
			j loopQuantificaParesVetor # Repete o loopQuantificaParesVetor 
		fimLoopQuantificaParesVetor:
		
		jr $ra # retorna para o local de chamada da função
		
	proc_num_ímpar: # Recebe o endereço do prumeiro elemento do vetor em $a1 e o comprimento dele em $a2 e retorna a quantidade de elementos ímpares do vetor em $v1 
		# $t0 -> ponteiro para o vetor de entrada
		# $t1 -> contador de números já verificados
		# $t2 -> armazena o valor do elemento do vetor atualmente apontado por $t0
		# $t3 -> constante 2, para ser usada nas divisões
		# $t4 -> armazena o resto da divisão para verificar se o número atualmente apontado por $t0 é par ou ímpar
		la $v1, ($zero) # Inicia o registrador de retorno da quantidade de ímpares $v1 com 0
		la $t0, ($a1) # Carrega o endereço do primeiro elemento do vetor de entrada no ponteiro $t0
		la $t1, ($zero) # Inicia o contador de números já verificados $t1 com 0
		li $t3, 2 # Carrega 2 no registrador $t3
		loop_proc_num_ímpar:
			bge $t1, $a2, fim_loop_proc_num_ímpar # Se o comprimento do vetor for maior que o do contador $t1 vai para fim_loop_proc_num_ímpar
			lw $t2, ($t0) # Carrega o registrador $t2 com o valor do elemento do vetor de entrada aponteado por $t0
			div $t2, $t3 # Divide o valor aramzenado em $t2 por 2
			mfhi $t4 # Salva o resto da divisão acima em $t4
			beq $t4, $zero, Not_impar_proc_num_ímpar # Se o resto da divisão 2 linhas acima for zero o número não é ímpar por isso deve ser pulada a linha abaixo
				addi $v1, $v1, 1 # Incrementa a quantidade de ímpares de $v1 em 1
			Not_impar_proc_num_ímpar: # Se $t2 não for ímpar pula a linha acima direto para esse label
			addi $t1, $t1, 1 # Incrementa o valor do contador $t1
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o próximo elemento do vetor de entrada
			j loop_proc_num_ímpar # Repete o loop_proc_num_ímpar
		fim_loop_proc_num_ímpar:
		
		jr $ra # retorna para o local de chamada da função
		
	proc_maior_soma: # Recebe em $a1 o endereço de um vetor e em $a2 seu comprimento e retorna em $v1 a quantidade de números com valor maior que o da quantidade de números
		# $t0 -> ponteiro para o vetor de entrada
		# $t1 -> valor do elemento apontado atualmente pelo ponteiro $t0
		# $t2 -> contador de elementos analisados do vetor de entrada
		la $v1, ($zero) # Inicia o registrador de retorno da quantidade de números maiores que o valor do comprimento do vetor de entrada $v1 com 0
		la $t0, ($a1) # Carrega o endereço do primeiro elemento do vetor de entrada no ponteiro $t0
		la $t2, ($zero) # Inicia o contador de números já verificados $t2 com 0
		loop_proc_maior_soma:
			lw $t1, ($t0) # Carrega em $t1 o valor do elemento atualmente apontado pelo ponteiro $t0
			ble $t1, $a2, menor_que_comprimento_proc_maior_soma # Se o valor armazenado em $t1 for menor que o comprimento do vetor de entrada pula o bloco abaixo indo para o label menor_que_comprimento_proc_maior_soma
				addi $v1, $v1, 1 # Incrementa em 1 o registrador de retorno da quantidade de números maiores que o valor do comprimento do vetor de entrada $v1
			menor_que_comprimento_proc_maior_soma: # Label usado para pular a linha acima se o valor de $t1 for menor que o de $a2
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o próximo elemento do vetor de entrada
			addi $t2, $t2, 1 # Incrementa o contador de elementos analisados do vetor de entrada $t2 em 1
			blt $t2, $a2, loop_proc_maior_soma # Enquanto a quantidade de elementos analisados $t2, for menor que o comprimento do vetor repete o loop_proc_maior_soma
		jr $ra # retorna para o local de chamada da função
		
	proc_prod_pos: # Recebe em $a1 o endereço do vetor ordenado de forma crescente e em $a2 o seu comprimento, retorna em $v1 o produto do menor ímpar com o maior par
		# $t0 -> ponteiro para o vetor de entrada
		# $t1 -> registrador que armazena o valor do elemento atualmente aponteado pelo ponteiro $t0
		# $t2 -> registrador do maior elemento par do vetor de entrada
		# $t3 -> registrador do menor elemento ímpar do vetor de entrada
		# $t4 -> contador da quantidade de elementos avaliados
		# $t5 -> constante 2, utilizada na divisão para verificar se o número é par ou ímpar
		# $t6 -> registrador que armazena o resto da divisão para comparar com 0 e verificar se o número é par ou ímpar
		# $t7 -> registrador booleano que armazena 0 se não tiver sido registrado nenhum ímpar em $t3 e 1 caso contrário 
		la $t0, ($a1) # Carrega o endereço do primeiro elemento do vetor de entrada no ponteiro $t0
		la $t4, ($zero) # Inicia com 0 o contador da quantide de elementos avaliados $t4
		li $t5, 2 # Carrega $t5 com a constante 2
		la $t7, ($zero) # Inicia com 0 o contador da quantidade de ímpares analisados no vetor $t7
		loop_proc_prod_pos:
			addi $t4, $t4, 1 # Incrementa em 1 o contador da quantidade de elementos avaliados $t4
			lw $t1, ($t0) # Carrega em $t1 o valor do elemento atualmente apontado pelo ponteiro $t0
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o próximo elemento do vetor de entrada
			div $t1, $t5 # Divide $t1 por 2
			mfhi $t6 #  Armazena o resto da divisão acima em $t6
			beqz $t6, maior_par_proc_prod_pos # Se o resto da divisão acima for igual a 0 o número em $t1 é par, portanto vai para o bloco maior_par_proc_prod_pos
				bgtz $t7, impar_maior_proc_prod_pos # Se $t7 for maior que 0 quer dizer que esse não é o primeiro ímpar avaliado e como esse é um vetor crescente ele não é o menor, então não deve ser registrado em $t3
					la $t3, ($t1) # Armazena o primeiro valor ímpar do vetor em $t3 como o menor ímpar, pois em um vetor crescente o primeiro ímpar é o menor deles
					addi $t7, $t7, 1 # Adiciona 1 no registrador $t7 para registrar que o menor ímpar já foi registrado
				impar_maior_proc_prod_pos: # Caso não seja o menor ímpar da sequência, ou seja, o primeiro do vetor, pula para esse label
				blt $t4, $a2, loop_proc_prod_pos # Enquanto a quantidade de números avaliados, $t4, for menor que a quantidade de números do vetor repete o loop_proc_prod_pos
			maior_par_proc_prod_pos: # Vem para esse bloco caso o número armazenado em $t1 seja par
				la $t2, ($t1) # Armazena em $t2 o valor do número par armazenado em $t1, pois o número par maior em um vetor crescente é o mais próximo do final
				blt $t4, $a2, loop_proc_prod_pos # Enquanto a quantidade de números avaliados, $t4, for menor que a quantidade de números do vetor repete o loop_proc_prod_pos
		mulo $v1, $t2, $t3 # Multiplica o maior par, armazenado em $t2, e o menor ímpar, armazenado em $t3, e salva o resultado em $v1 
		jr $ra # retorna para o local de chamada da função
		
	proc_ord: # Recebe em $a1 o endereço do vetor e em $a2 o seu comprimento e ordena-o de forma crescente
		li $t0, 1 # Inicia o contador com 1
		j Wnext001# pula para o bloco de verificação do fim da função
		Wbody001: # Começo da função, onde reinicia o loop, Inicia contadores e ponteiros               
			sll $t4, $t0, 2    
			add $t4, $a1, $t4  
			lw $t3, 0($t4)
			addi $t1, $t0, -1
			j Wnext002 # Vai para Wnext002
		Wbody002: # Segunda parte da função
			sll  $t4, $t1, 2
			add $t4, $a1, $t4
			lw $t2, 0($t4)
			addi $t4, $t4, 4
			sw $t2, 0($t4)
			addi $t1, $t1, -1
		Wnext002: # Parte que deve ser repetida após os dois Wbody
			blt $t1, $zero, Wdone002
			sll  $t4, $t1, 2    
			add $t4, $a1, $t4    
			lw $t2, 0($t4)     
			bgt $t2, $t3, Wbody002
		Wdone002: # Encerramento da função, incrementando contadores e ponteiros                 
			add  $t4, $t1, 1    
			sll  $t4, $t4, 2 
			add $t4, $a1, $t4
			sw $t3, 0($t4)         
			addi $t0, $t0, 1
		Wnext001: # Verifica se o contador de repetições $t0 possui valor menor que o comprimento do vetor, caso sim repete a função a partir do label Wbody001, se não encerra a função
			blt $t0,$a2, Wbody001
		 
	 	jr $ra # retorna para o local de chamada da função
