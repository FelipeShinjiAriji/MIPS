.macro readInt # lê um inteiro inserido pelo usuário e salva em $v0
	li $v0, 5
	syscall
.end_macro

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

.macro printInt (%int) # salva em $a0 o valor fornecido no parâmetro como inteiro e imprime-o
	la $a0, (%int)
	li $v0, 1 # código de impressão de inteiro
	syscall
.end_macro

.data
	
	vetA: .space 40
	vetB: .space 40
	
	
.text

	Main:
	
		li $a2, 10 # insere 10 no resgistrador de parametro $a2
		li $a3, 2 # insere 2 no resgistrador de parametro $a3
		
		printString("Preencha o primeiro vetor vetA: ")	
		newline
		la $a1, vetA # Carrega o endereço do primeiro elemento do vetor a ser preenchido, vetA, no registrador de parametro $a1 
		jal lerInteiros
		newline
		
		printString("Preencha o primeiro vetor vetB: ")	
		newline
		la $a1, vetB # Carrega o endereço do primeiro elemento do vetor a ser preenchido, vetB, no registrador de parametro $a1 
		jal lerInteiros
		newline
		
		printString("Somatória dos elementos das posições pares de VetA é:  ")
		la $a1, vetA # Carrega o endereço do primeiro elemento do vetor preenchido, vetA, no registrador de parametro $a1 
		li $a0, 0 # Carrega o número do indice do primeiro elemento a ser somado em $a0
		jal somaElementos
		printInt($v1)
		newline
		
		printString("Somatória dos elementos das posições ímpares de VetB é:  ")
		la $a1, vetB # Carrega o endereço do primeiro elemento do vetor preenchido, vetB, no registrador de parametro $a1 
		li $a0, 1 # Carrega o número do indice do primeiro elemento a ser somado em $a0
		jal somaElementos
		printInt($v1)
		newline
		
	endProgram
	
	lerInteiros: # Recebe o endereço de um vetor para preencher em $a1 e lê a quantidade de números inteiros positivos do usuário equivalente ao valor recebido em $a2, salvando-os no vetor recebido
		# $t0 -> ponteiro para o próximo espaço vazio do vetor
		# $t1 -> contador de valores recebidos pelo usuário
		li $t1, 0 # Zera o registrador da quantidade de números lidos $t1
		la $t0, ($a1) # Aponta o ponteiro $t0 para o primeiro espaço livre do vetor
		loopLerInteiros:
			printString("Insira o próximo número a ser inserido no vetor: ")
			readInt
			addi $t1, $t1, 1 # incrementa a quantidade de n números inteiros positivos lidos em $t1
			sw $v0, ($t0) # Armazena o valor recebido pelo usuário no próximo espaço vazio do vetor
			addi $t0, $t0, 4 # incrementa o ponteiro $t0 para o próximo espaço vazio do vetor
			blt $t1, $a2,  loopLerInteiros # Enquanto o número de elementos lidos for menor do que 15 repete o loopLerInteiros
		jr $ra
		
	somaElementos: # Recebe o endereço do primeiro elemento do vetor em $a1, o comprimento do vetor em $a2, a distância para o próximo elemento a ser somado em em $a3 e o indice do primeiro elemento a ser somado $a0 e retorna em $v1 a soma desses elementos do vetor
		# $t0 -> ponteiro para o elemento a ser somado
		# $t1 -> valor do elemento a ser somado
		# $t2 -> contador do comprimento percorrido do vetor
		# $t3 -> valor que incrementa o ponteiro
		li $v1, 0 # Zera o registrador de retorino $v0
		li $t2, 0 # Inicia o contador com 0
		la $t0, ($a1) # Aponta o ponteiro para o endereço do primeiro elemento do vetor
		mulo $t3, $a0, 4 # Multiplica o índice do primeiro elemento a ser somado por 4 para incrementar o ponteiro e salva no registrador auxiliar $t3
		add $t0, $t0, $t3 # Incrementa o ponteiro para o primeiro elemento a ser somado
		mulo $t3, $a3, 4 # Multiplica a distância até o próximo elemento por 4 para incrementar o ponteiro e salva em $t3
		loopSomaElementos:
			lw $t1, ($t0) # Carrega o valor do elemento a ser somado em $t1
			add $v1, $v1, $t1 # Soma de $t1 com o valor do registrador de retorno $v0 
			add $t0, $t0, $t3 # Incrementa o ponteiro para o próximo elemento a ser somado
			add $t2, $t2, $a3 # Incrementa o contador com o comprimento percorrido com a repetição atual do loop
			blt $t2, $a2, loopSomaElementos # Enquanto o contador de comprimento percorrido for menor que o comprimento do vetor repete o loopSomaElementos
			
		jr $ra
