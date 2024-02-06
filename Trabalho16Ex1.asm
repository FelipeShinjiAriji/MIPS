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

.macro newline # quebra linha
	li $a0, 10 # C�digo ASCII para ("\n")	
	li $v0, 11 # C�digo de impress�o de caractere
	syscall
.end_macro
	
.macro readInt # l� um inteiro inserido pelo usu�rio e salva em $v0
	li $v0, 5
	syscall
.end_macro

.macro printStringByLabel (%string) # salva em $a0 a string do endere�o fornecido como par�metro e imprime-a
	la $a0, %string 
	li $v0, 4 # c�digo de impress�o de String
	syscall
.end_macro

.text
	
	Main:
		
		printString("Insira a quantidade de letras do alfabeto desejadas nas combina��es: ")
		readInt
		la $a1, ($v0)
		
		jal geraCombinacoesDeNLetras
		
		endProgram

	geraCombinacoesDeNLetras: # Recebe em $a1 um N inteiro positivo e imprime todas as combina��es poss�veis sem repeti��o de letras das N primeiras letras do alfabeto
		.data 
			stringGeraCombinacoesDeNLetras: .space 26
			
		.text
			# $t0 -> ponteiro para a String utilizada para escrever as combina��es
			# $t1 -> registrador do n�mero utilizado para representar o caracter a ser colocado na String
			# $t2 -> contador da quantidade de caracteres inseridos na String
			# $t3 -> contador decrescente da quantidade de combina��es a serem impressas
			# $t4 -> ponteiro secund�rio para a String utilizada para escrever as combina��es
			# $t5 -> registrador auxiliar do n�mero utilizado para representar o caracter a ser colocado na String
			# $t6 -> contador de repeti��es do loopCriaCombinacoesInternoGeraCombinacoesDeNLetras 
			blez $a1, entradaInvalidaGeraCombinacoesDeNLetras # Se a quantidade de letras for menor ou igual a zero a opera��o � imposs�vel
			bgt $a1, 26, entradaInvalidaGeraCombinacoesDeNLetras # Se a quantidade de letras for maior que 26 a opera��o � imposs�vel por faltar letras no alfabeto
			la $t0, stringGeraCombinacoesDeNLetras # Carrega o endere�o do primeiro elemento da String a ser usada na fun��o no ponteiro $t0
			li $t1, 65 # Inicia registrador $t1 com 65 o n�mero ASCII para A
			la $t2, ($zero) # Inicia o contador de caracteres inseridos na String $t2 com 0
			loopPreencheStringGeraCombinacoesDeNLetras:
				sb $t1, ($t0) # Armazena o caracter ASCII armazenado em $t1 no espa�o da String apontado pelo ponteiro $t0
				addi $t0, $t0, 1 # Incrementa o ponteiro $t0 para o pr�ximo espa�o vazio da String 
				addi $t1, $t1, 1 # Soma 1 ao valor de $t1 para trocar para a pr�xima letra do alfabeto da tabela ASCII
				addi $t2, $t2, 1 # Incrementa o contador da quantidade de caracteres inseridos na String $t2 em 1
				blt $t2, $a1, loopPreencheStringGeraCombinacoesDeNLetras # Enquanto o contador $t2 for menor que a quantidade de letras desejadas repete o loopPreencheStringGeraCombinacoesDeNLetras
			sw $ra, ($sp) # Salva o retorno para a main em $sp
			jal fatorial # Calcula o fatorial do n�mero de entrada, pois esse resultado � o quantidade de combin��es poss�veis sem repetir caracter
			la $t3, ($v1) # Carrega o resultado do fatorial acima em $t3 para funcionar como contador decresecente da quantidade de combina��es a serem impressas
			lw $ra, ($sp) # Recupera o retorno para a main
			loopCriaCombinacoesGeraCombinacoesDeNLetras:
				la $t0, stringGeraCombinacoesDeNLetras # Reseta a o ponteiro para o primeiro elemento da String
				addi $t4, $t0, 1 # Carrega no ponteiro $t4 o endere�o do segundo elemento da String
				li $t6, 1 # Inicia o contador de repeti��es do loopCriaCombinacoesInternoGeraCombinacoesDeNLetras com 1
				loopCriaCombinacoesInternoGeraCombinacoesDeNLetras:
					printStringByLabel(stringGeraCombinacoesDeNLetras)
					newline
					lb $t1, ($t0) # Carrega em $t1 o valor do elemento atualmente apontado pelo ponteiro $t0
					lb $t5, ($t4) # Carrega em $t5 ovalor do pr�ximo elemento a ser apontado pelo ponteiro $t0
					sb $t5, ($t0) # Armazena o caracter do elemento anteriomente apontado por $t4 no espa�o do apontado por $t0
					sb $t1, ($t4) # Armazena o caracter do elemento anteriomente apontado por $t0 no espa�o do apontado por $t4
					la $t0, ($t4) # Incrementa o ponteiro $t0 para o pr�ximo elemento da String, ou seja o apontado por $t4
					addi $t4, $t4, 1 # Incrementa o ponteiro $t4 para o pr�ximo elemento da String 
					subi $t3, $t3,1 # Decrementa o contador decrescente da quantidade de combina��es a serem impressas $t3 em 1
					addi $t6, $t6,1 # Incrementa o contador de repeti��es do loopCriaCombinacoesInternoGeraCombinacoesDeNLetras em 1
					blt $t6, $a1, loopCriaCombinacoesInternoGeraCombinacoesDeNLetras # Enquanto o valor do contador $t6 for menor do que o n�mero inserido como par�metro em $a1 repete o loopCriaCombinacoesInternoGeraCombinacoesDeNLetras
				bgtz $t3, loopCriaCombinacoesGeraCombinacoesDeNLetras # Enquanto o valor de $t3 for maior que 0 repete o loopCriaCombinacoesGeraCombinacoesDeNLetras
			jr $ra
			entradaInvalidaGeraCombinacoesDeNLetras:
				printString("Entrada inv�lida.")
				endProgram
				
	fatorial: # Recebe em $a1 um n�mero inteiro possitivo e retorna em $v1 seu fatorial
		# $t0 -> contador decrescente da fun��o fatorial
		bltz $a1, entradaInvalidaFatorial # Se o n�mero inserido for negativo n�o � poss�vel calcular o fatorial desse n�mero
		beqz $a1, entradaZeroFatorial # Se o valor de entrada for 0, utiliza-se a regra especial de que 0! = 1
		li $v1, 1 # Incia o retorno do fatorial com 1
		la $t0, ($a1) # Incia o contador decrescente $t0 com o valor recebido de entrada 
		loopFatorial:
			mulo $v1, $v1, $t0 # Multiplica o valor de $v1 pelo valor atual do contador $t0
			subi $t0, $t0, 1 # decrementa o contador $t0 em 1
			bgt $t0, 1, loopFatorial # Enquanto o valor de $t0 for maior que 1 repete o loopFatorial 
		jr $ra
		entradaZeroFatorial:
			li $v1, 1 # Salva o registrador de retorno $v1 como 1, pois por defini��o 0! = 1
			jr $ra
		entradaInvalidaFatorial:
			printString("Entrada inv�lida.")
			endProgram
