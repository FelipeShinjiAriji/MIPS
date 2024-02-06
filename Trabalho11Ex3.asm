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

.macro printInt # imprime o inteiro do registrador $a0
	li $v0, 1
	syscall
.end_macro

.macro readInt # lê um inteiro inserido pelo usuário e salva em $v0
	li $v0, 5
	syscall
.end_macro

.macro endProgram # encerra o programa
	li $v0, 10
	syscall
.end_macro

.data
	
	A: .space 60
	B: .space 28
	inter: .space 28
	vetorElementosUnicos: .space 28
	
.text

	Main:
	
		printString("Preencha o vetor A: ")
		newline
		la $a1, A
		li $a2, 15
		jal lerInteiros
		newline
		
		printString("Preencha o vetor B: ")
		newline
		la $a1, B
		li $a2, 7
		jal lerInteiros
		newline
		
		printString("Os valores comuns aos vetores A e B são: ")
		newline
		la $a1, B
		li $a2, 7
		la $a3, vetorElementosUnicos
		jal criaVetorElementosUnicos
		la $a0, A
		li $a1, 15
		la $a2, vetorElementosUnicos
		la $a3, ($v1)
		jal criaVetorInterseccao
		la $a1, inter
		la $a2, ($v1)
		jal printVetorInt
		
		endProgram
		
			
		
	lerInteiros: # Recebe o endereço de um vetor para preencher em $a1 e lê a quantidade de números inteiros positivos do usuário equivalente ao valor recebido em $a2, salvando-os no vetor recebido
		# $t0 -> ponteiro para o próximo espaço vazio do vetor
		# $t1 -> contador de valores recebidos pelo usuário
		la $t1, ($zero) # Zera o registrador da quantidade de números lidos $t1
		la $t0, ($a1) # Aponta o ponteiro $t0 para o primeiro espaço livre do vetor
		loopLerInteiros:
			printString("Insira o próximo número a ser inserido no vetor: ")
			readInt
			addi $t1, $t1, 1 # incrementa a quantidade de n números inteiros positivos lidos em $t1
			sw $v0, ($t0) # Armazena o valor recebido pelo usuário no próximo espaço vazio do vetor
			addi $t0, $t0, 4 # incrementa o ponteiro $t0 para o próximo espaço vazio do vetor
			blt $t1, $a2,  loopLerInteiros # Enquanto o número de elementos lidos for menor do que 15 repete o loopLerInteiros
		jr $ra
	
			
	criaVetorInterseccao: # Recebe o endereço do primeiro elemento de um vetor A em $a0  e de outro vetor B em $a2, o comprimento do vetor A em $a1 e o comprimento do vetor B em $a3 e cria um vetor de elementos comuns aos 2 vetores na label inter	e retorna seu comprimento em $v1
		# $t0 -> ponteiro para o elemento atualmente analisado do vetor B
		# $t1 -> valor do elemento apontado pelo ponteiro $t0 no vetor B
		# $t2 -> contador de iterações do vetor B 
		# $t3 -> ponteiro para o elemento atualmente analisado do vetor A
		# $t4 -> valor do elemento apontado pelo ponteiro $t3 no vetor A
		# $t5 -> contador de iterações do vetor A
		# $t6-> ponteiro para o próximo espaço vazio do vetor inter
		la $v1, ($zero) # Inicia com 0 o contador do comprimento de inter
		la $t0, ($a2) # Carrega no ponteiro $t0 o endereço para o primeiro elemento do vetor B
		la $t2, ($zero) # Inicia com 0 o contador de iterações do vetor B em $t2
		la $t6, inter # Carrega o endereço do primeiro elemento do vetor intersecção criado no ponteiro $t6
		loopCriaVetorInterseccaoPercorreVetorB:
			la $t5, ($zero) # Inicia com 0 o contador de iterações do vetor A em $t5
			la $t3, ($a0) # Carrega no ponteiro $t3 o endereço para o primeiro elemento do vetor A
			lw $t1, ($t0)
			loopCriaVetorInterseccaoPercorreVetorA:
				lw $t4, ($t3)
				bne $t1, $t4, ValoresDiferentesCriaVetorInterseccao # Se os valores forem diferentes pula o bloco abaixo, passando direto para o label ValoresDiferentes
					sw $t1, ($t6) # Se os valores forem iguais, é parte da intersecção, então é salvo no próximo elemento vazio do vetor inter
					addi $t6, $t6, 4 # Incrementa o ponteiro do vetor inter para o próximo elemento vazio
					addi $v1, $v1, 1 # incrementa o contador de comprimento do vetor inter
					addi $t0, $t0, 4 # Incrementa o ponteiro do vetor B para o próximo elemento $t0
					addi $t2, $t2, 1 # Incrementa o contador de iterações do vetor B $t2
					blt $t2, $a3, loopCriaVetorInterseccaoPercorreVetorB # Enquanto o comtandor de interações $t2 tiver valor menor que o comprimento do vetor B repete o loopCriaVetorInterseccaoPercorreVetorB
					j encerraCriaVetorInterseccao
				ValoresDiferentesCriaVetorInterseccao:
				addi $t3, $t3, 4 # Incrementa o ponteiro do vetor A para o próximo elemento
				addi $t5, $t5, 1 # Incrementa o contador de iterações do vetor A $t5
				blt $t5, $a1, loopCriaVetorInterseccaoPercorreVetorA # Enquanto o comtandor de interações $t5 tiver valor menor que o comprimento do vetor A repete o loopCriaVetorInterseccaoPercorreVetorA
			addi $t0, $t0, 4 # Incrementa o ponteiro do vetor B para o próximo elemento $t0
			addi $t2, $t2, 1 # Incrementa o contador de iterações do vetor B $t2
			blt $t2, $a3, loopCriaVetorInterseccaoPercorreVetorB # Enquanto o comtandor de interações $t2 tiver valor menor que o comprimento do vetor B repete o loopCriaVetorInterseccaoPercorreVetorB
		encerraCriaVetorInterseccao:
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
		
	criaVetorElementosUnicos: # Recebe o endereço do primeiro elemento do vetor em $a1 e o comprimento dele em $a2 e cria um vetor igual ao recebido, porém sem elementos repetidos, no endereço inserido em $a3 retornando o seu comprimento em $v1
		# $t0 -> ponteiro para o vetor de entrada
		# $t1 -> valor do elemento do vetor de entrada apontado pelo vetor $t0
		# $t2 -> contador de elementos verificados
		# $t3 -> ponteiro para o elemento do vetor a ser comparado com o do ponteiro $t0
		# $t4 -> valor do elemento do vetor de entrada apontado pelo vetor $t3
		# $t5 -> contador de elementos comparados
		# $t6 -> ponteiro para o vetor de saída
		la $t0, ($a1) # Carrega o endereço do primeiro elemento do vetor de entrada no ponteiro $t0
		la $t2, ($zero) # Inicia com 0 o contador  $t2
		la $t6, ($a3) # Carrega o endereço do primeiro espaço vazio do vetor de saída no ponteiro $t3
		loop1CriaVetorElementosUnicos:
			lw $t1, ($t0) # Carrega o valor do elemento do vetor de entrada apontado pelo ponteiro $t0 em $t1
			addi $t2, $t2, 1  # Incrementa o contador $t2 em 1
			la $t5, ($t2) # Inicia com o valor do contador $t2 o contador $t5
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o próximo elemento do vetor de entrada
			la $t3, ($t0) # Carrega o endereço do próximo elemento do vetor no ponteiro $t3
			loop2CriaVetorElementosUnicos:
				lw $t4, ($t3) # Carrega o valor do elemento do vetor de entrada apontado pelo ponteiro $t3
				beq $t1, $t4,  loop1CriaVetorElementosUnicos# Se o valor dos elementos forem iguais pula para o próximo elemento sem salvar o atual no vetor de saída
				addi $t5, $t5, 1 # Incrementa o contador $t5 em 1
				addi $t3, $t3, 4 # Incrementa o ponteiro $t3 para o próximo elemento
				blt $t5, $a2, loop2CriaVetorElementosUnicos # Enquanto o valor do contador $t5 for menor que o comprimento do vetor de entrada repete o loop2CriaVetorElementosUnicos
			sw $t1, ($t6) # Se não houver elemento posterior ao armazenado em $t1 com valor igual ao dele, armazena seu valor no próximo espaço vazio do vetor de saída
			addi $t6, $t6, 4 # Incrementa o ponteiro $t6 para o próximo espaço vazio do vetor de saída
			addi $v1, $v1, 1 # Incrementa o valor do comprimento do vetor de saída, salvo em $v1, em 1
			blt $t2, $a2, loop1CriaVetorElementosUnicos # Enquanro o valor do contador $t2 for menor que o comprimento do vetor de entrada repete o loop1CriaVetorElementosUnicos
		jr $ra