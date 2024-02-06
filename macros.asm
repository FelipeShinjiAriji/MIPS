.macro endProgram # encerra o programa
	li $v0, 10
	syscall
.end_macro
	
.macro printInt (%int) # salva em $a0 o valor fornecido no parâmetro como inteiro e imprime-o
	la $a0, (%int)
	li $v0, 1 # código de impressão de inteiro
	syscall
.end_macro
	
.macro printFloat (%float) # salva em $f12 o valor fornecido no parâmetro como float e imprime-o
	l.s $f12, (%float)
	li $v0, 2 # código de impressão de float
	syscall
.end_macro
	
.macro printDouble (%double) # salva em $f12 o valor fornecido no parâmetro como double e imprime-o
	l.d $f12, (%double)
	li $v0, 3 # código de impressão de double
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

.macro printFloat  # imprime o valor dentro de $f12 como float
	li $v0, 2 # código de impressão de float
	syscall
.end_macro
	
.macro printStringByLabel (%string) # salva em $a0 a string do endereço fornecido como parâmetro e imprime-a
	la $a0, %string 
	li $v0, 4 # código de impressão de String
	syscall
.end_macro
	
.macro printSpace #imprime um espaço 
	li $a0, 32 # Código ASCII para espaço
	li $v0, 11 # código de impressão de caractere
	syscall # Imprime o espaço
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
	
.macro readFloat # lê um float inserido pelo usuário e salva em $v0
	li $v0, 6
	syscall
.end_macro
	
.macro readDouble # lê um double inserido pelo usuário e salva em $v0
	li $v0, 7
	syscall
.end_macro

.macro readChar # lê um caracter inserido pelo usuário e salva em $v0
	li $v0, 12
	syscall
.end_macro

.macro readString(%inputAddress, %maxCharacters) # Lê uma String com número máximo de characteres fornecidos no segundo argumento e salva-a no endereço fornecido no primeiro argumento
la $a0, %inputAddress
la $a1, %maxCharacters
li $v0, 8
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

.macro mallocInt(%intQuantity) # Aloca dinamicamente o espaço para a quantidade de inteiros passada no parâmetro e salva o endereço alocado em $v0 
	mul  $a0, %intQuantity, 4 # Salva em $a0 a quantidade de espaço de memória necessário para alocar a quantidade de int inserida como parâmetro
	li $v0, 9
	syscall
.end_macro
