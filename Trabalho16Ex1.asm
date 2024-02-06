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

.macro newline # quebra linha
	li $a0, 10 # Código ASCII para ("\n")	
	li $v0, 11 # Código de impressão de caractere
	syscall
.end_macro
	
.macro readInt # lê um inteiro inserido pelo usuário e salva em $v0
	li $v0, 5
	syscall
.end_macro

.macro printStringByLabel (%string) # salva em $a0 a string do endereço fornecido como parâmetro e imprime-a
	la $a0, %string 
	li $v0, 4 # código de impressão de String
	syscall
.end_macro

.text
	
	Main:
		
		printString("Insira a quantidade de letras do alfabeto desejadas nas combinações: ")
		readInt
		la $a1, ($v0)
		
		jal geraCombinacoesDeNLetras
		
		endProgram

	geraCombinacoesDeNLetras: # Recebe em $a1 um N inteiro positivo e imprime todas as combinações possíveis sem repetição de letras das N primeiras letras do alfabeto
		.data 
			stringGeraCombinacoesDeNLetras: .space 26
			
		.text
			# $t0 -> ponteiro para a String utilizada para escrever as combinações
			# $t1 -> registrador do número utilizado para representar o caracter a ser colocado na String
			# $t2 -> contador da quantidade de caracteres inseridos na String
			# $t3 -> contador decrescente da quantidade de combinações a serem impressas
			# $t4 -> ponteiro secundário para a String utilizada para escrever as combinações
			# $t5 -> registrador auxiliar do número utilizado para representar o caracter a ser colocado na String
			# $t6 -> contador de repetições do loopCriaCombinacoesInternoGeraCombinacoesDeNLetras 
			blez $a1, entradaInvalidaGeraCombinacoesDeNLetras # Se a quantidade de letras for menor ou igual a zero a operação é impossível
			bgt $a1, 26, entradaInvalidaGeraCombinacoesDeNLetras # Se a quantidade de letras for maior que 26 a operação é impossível por faltar letras no alfabeto
			la $t0, stringGeraCombinacoesDeNLetras # Carrega o endereço do primeiro elemento da String a ser usada na função no ponteiro $t0
			li $t1, 65 # Inicia registrador $t1 com 65 o número ASCII para A
			la $t2, ($zero) # Inicia o contador de caracteres inseridos na String $t2 com 0
			loopPreencheStringGeraCombinacoesDeNLetras:
				sb $t1, ($t0) # Armazena o caracter ASCII armazenado em $t1 no espaço da String apontado pelo ponteiro $t0
				addi $t0, $t0, 1 # Incrementa o ponteiro $t0 para o próximo espaço vazio da String 
				addi $t1, $t1, 1 # Soma 1 ao valor de $t1 para trocar para a próxima letra do alfabeto da tabela ASCII
				addi $t2, $t2, 1 # Incrementa o contador da quantidade de caracteres inseridos na String $t2 em 1
				blt $t2, $a1, loopPreencheStringGeraCombinacoesDeNLetras # Enquanto o contador $t2 for menor que a quantidade de letras desejadas repete o loopPreencheStringGeraCombinacoesDeNLetras
			sw $ra, ($sp) # Salva o retorno para a main em $sp
			jal fatorial # Calcula o fatorial do número de entrada, pois esse resultado é o quantidade de combinções possíveis sem repetir caracter
			la $t3, ($v1) # Carrega o resultado do fatorial acima em $t3 para funcionar como contador decresecente da quantidade de combinações a serem impressas
			lw $ra, ($sp) # Recupera o retorno para a main
			loopCriaCombinacoesGeraCombinacoesDeNLetras:
				la $t0, stringGeraCombinacoesDeNLetras # Reseta a o ponteiro para o primeiro elemento da String
				addi $t4, $t0, 1 # Carrega no ponteiro $t4 o endereço do segundo elemento da String
				li $t6, 1 # Inicia o contador de repetições do loopCriaCombinacoesInternoGeraCombinacoesDeNLetras com 1
				loopCriaCombinacoesInternoGeraCombinacoesDeNLetras:
					printStringByLabel(stringGeraCombinacoesDeNLetras)
					newline
					lb $t1, ($t0) # Carrega em $t1 o valor do elemento atualmente apontado pelo ponteiro $t0
					lb $t5, ($t4) # Carrega em $t5 ovalor do próximo elemento a ser apontado pelo ponteiro $t0
					sb $t5, ($t0) # Armazena o caracter do elemento anteriomente apontado por $t4 no espaço do apontado por $t0
					sb $t1, ($t4) # Armazena o caracter do elemento anteriomente apontado por $t0 no espaço do apontado por $t4
					la $t0, ($t4) # Incrementa o ponteiro $t0 para o próximo elemento da String, ou seja o apontado por $t4
					addi $t4, $t4, 1 # Incrementa o ponteiro $t4 para o próximo elemento da String 
					subi $t3, $t3,1 # Decrementa o contador decrescente da quantidade de combinações a serem impressas $t3 em 1
					addi $t6, $t6,1 # Incrementa o contador de repetições do loopCriaCombinacoesInternoGeraCombinacoesDeNLetras em 1
					blt $t6, $a1, loopCriaCombinacoesInternoGeraCombinacoesDeNLetras # Enquanto o valor do contador $t6 for menor do que o número inserido como parâmetro em $a1 repete o loopCriaCombinacoesInternoGeraCombinacoesDeNLetras
				bgtz $t3, loopCriaCombinacoesGeraCombinacoesDeNLetras # Enquanto o valor de $t3 for maior que 0 repete o loopCriaCombinacoesGeraCombinacoesDeNLetras
			jr $ra
			entradaInvalidaGeraCombinacoesDeNLetras:
				printString("Entrada inválida.")
				endProgram
				
	fatorial: # Recebe em $a1 um número inteiro possitivo e retorna em $v1 seu fatorial
		# $t0 -> contador decrescente da função fatorial
		bltz $a1, entradaInvalidaFatorial # Se o número inserido for negativo não é possível calcular o fatorial desse número
		beqz $a1, entradaZeroFatorial # Se o valor de entrada for 0, utiliza-se a regra especial de que 0! = 1
		li $v1, 1 # Incia o retorno do fatorial com 1
		la $t0, ($a1) # Incia o contador decrescente $t0 com o valor recebido de entrada 
		loopFatorial:
			mulo $v1, $v1, $t0 # Multiplica o valor de $v1 pelo valor atual do contador $t0
			subi $t0, $t0, 1 # decrementa o contador $t0 em 1
			bgt $t0, 1, loopFatorial # Enquanto o valor de $t0 for maior que 1 repete o loopFatorial 
		jr $ra
		entradaZeroFatorial:
			li $v1, 1 # Salva o registrador de retorno $v1 como 1, pois por definição 0! = 1
			jr $ra
		entradaInvalidaFatorial:
			printString("Entrada inválida.")
			endProgram
