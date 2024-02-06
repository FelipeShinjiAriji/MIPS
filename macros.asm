.macro endProgram # encerra o programa
	li $v0, 10
	syscall
.end_macro
	
.macro printInt (%int) # salva em $a0 o valor fornecido no par�metro como inteiro e imprime-o
	la $a0, (%int)
	li $v0, 1 # c�digo de impress�o de inteiro
	syscall
.end_macro
	
.macro printFloat (%float) # salva em $f12 o valor fornecido no par�metro como float e imprime-o
	l.s $f12, (%float)
	li $v0, 2 # c�digo de impress�o de float
	syscall
.end_macro
	
.macro printDouble (%double) # salva em $f12 o valor fornecido no par�metro como double e imprime-o
	l.d $f12, (%double)
	li $v0, 3 # c�digo de impress�o de double
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

.macro printFloat  # imprime o valor dentro de $f12 como float
	li $v0, 2 # c�digo de impress�o de float
	syscall
.end_macro
	
.macro printStringByLabel (%string) # salva em $a0 a string do endere�o fornecido como par�metro e imprime-a
	la $a0, %string 
	li $v0, 4 # c�digo de impress�o de String
	syscall
.end_macro
	
.macro printSpace #imprime um espa�o 
	li $a0, 32 # C�digo ASCII para espa�o
	li $v0, 11 # c�digo de impress�o de caractere
	syscall # Imprime o espa�o
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
	
.macro readFloat # l� um float inserido pelo usu�rio e salva em $v0
	li $v0, 6
	syscall
.end_macro
	
.macro readDouble # l� um double inserido pelo usu�rio e salva em $v0
	li $v0, 7
	syscall
.end_macro

.macro readChar # l� um caracter inserido pelo usu�rio e salva em $v0
	li $v0, 12
	syscall
.end_macro

.macro readString(%inputAddress, %maxCharacters) # L� uma String com n�mero m�ximo de characteres fornecidos no segundo argumento e salva-a no endere�o fornecido no primeiro argumento
la $a0, %inputAddress
la $a1, %maxCharacters
li $v0, 8
syscall
.end_macro

.macro readFile(%fileAddress, %readFileBuffer) # L� o arquivo do endere�o fornecido como 1� par�metro, copia o arquivo para o endere�o do 2� par�metro e retorna em $s0 o file descriptor e em $s1 a quantidade de caracteres desse arquivo
	.data
		readFileFileAddress: .asciiz %fileAddress
		readFileError: .asciiz "ERROR: Arquivo n�o encontrado."
	.text
		li $v0, 13
		la $a0, readFileFileAddress
		li $a1, 0 # C�digo para read only
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

.macro closeFile # Fecha o arquivo que o descritor est� armazenado em $s0
	li $v0, 16
	move $a0, $s0
	syscall
.end_macro

.macro mallocInt(%intQuantity) # Aloca dinamicamente o espa�o para a quantidade de inteiros passada no par�metro e salva o endere�o alocado em $v0 
	mul  $a0, %intQuantity, 4 # Salva em $a0 a quantidade de espa�o de mem�ria necess�rio para alocar a quantidade de int inserida como par�metro
	li $v0, 9
	syscall
.end_macro
