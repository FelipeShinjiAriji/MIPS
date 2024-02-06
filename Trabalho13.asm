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

.macro readString(%inputAddress, %maxCharacters) # L� uma String com n�mero m�ximo de characteres fornecidos no segundo argumento e salva-a no endere�o fornecido no primeiro argumento
la $a0, %inputAddress
la $a1, %maxCharacters
li $v0, 8
syscall
.end_macro

.data

	intCPF: .space 44
	stringCPF: .asciiz "111111111-11"

.text

	Main:
		
		printString("Insira o seu CPF no seguinte formato: 111111111-11: ")
		readString(stringCPF, 14)
		la $a1, stringCPF
		la $a2, intCPF
		jal stringCPFToIntVector
		la $a1, intCPF
		jal verificaCPF
		beqz $v1, CPFvalido
			printString("O CPF inserido � inv�lido.")
			endProgram
		CPFvalido:
			printString("O CPF inserido � v�lido.")
			endProgram
		
	stringCPFToIntVector: # Recebe em $a1 o endere�o do primeiro elemento de uma String de CPF no formato "111111111-11" e cria um vetor de inteiros no endere�o recebido em $a2
		# :$t0 -> ponteiro para o caracter da String atualmente processado
		# $t1 -> caracter da String atualmente processado
		# $t2 -> ponteiro para o pr�ximo elemento vazio do vetor de retorno
		# $t3 -> Auxiliar que armazena temporariamente o inteiro a ser armazenado no vetor 
		# $t4 -> contador da quantidade de d�gitos convertido de String para int
		la $t0, ($a1) # Carrega no ponteiro o endere�o do primeiro caracter da String a ser convertida
		la $t2, ($a2) # Carrega no ponteiro o endere�o do primeiro elemento vazio do vetor de retorno
		la $t4, ($zero) # Inicia o contador $t4 com 0
		loopStringCPFToIntVector:
			lb $t1, ($t0) # Carrega em $t1 o caracter da String apontado pelo ponteiro $t0
			addi $t0, $t0, 1 # Incrementa o ponteiro para a String de entrada $t0, para o pr�ximo caracter
			addi $t4, $t4, 1 # Incrementa em 1 o contador da quantidade de d�gitos convertido de String para int $t4
			bne $t4, 10, numberDigitStringCPFToIntVector # Se a quantidade de d�gitos do n�mero sendo convertido atualmente de String para int em $t6 n�o for igual � 10 n�o se deve realisar a linha abaixo
				bne $t1, 45, errorStringCPFToIntVector # Se o valor de $t1 n�o for 45 significa que o 10 d�gito n�o � um tra�o portanto o formato est� errado, nesse caso gera mensagem de erro e finaliza o programa
				j loopStringCPFToIntVector
			numberDigitStringCPFToIntVector:
				ble $t1, 47, errorStringCPFToIntVector # Se o valor na tabaela ASCII for menor ou igual � 47 n�o � um d�gito num�rico ent�o acontece um erro na fun��o
				bge $t1, 58, errorStringCPFToIntVector # Se o valor na tabaela ASCII for maior ou igual � 58 n�o � um d�gito num�rico ent�o acontece um erro na fun��o
				subi $t3, $t1, 48 # Subtrai 48 do valor armazenado em $t1, para converter de valor de tabela ASCII para o valor num�rico normal e salva em $t3  
				sw $t3, ($t2) # Salva o valor armazenado em $t3 como int no endere�o apontado por $t2
				addi $t2, $t2, 4 # Incrementa o ponteiro para $t2 para o pr�ximo elemento vazio do vetor de retorno
				ble $t4, 11, loopStringCPFToIntVector # Enquanto o valor do contador $t4 for menor ou igual � 12 repete o loopStringCPFToIntVector
		jr $ra
		errorStringCPFToIntVector:
			printString("Error: CPF inserido � inv�lido.")
			endProgram
		
	verificaCPF: # Recebe o endere�o do primeiro elemento de um vetor de inteiros correspondentes aos d�gitos num�ricos de um CPF em $a1 e retorna em $v1 0 se os bits de verifica��o estiverem corretos e 1 caso contr�rio
		# $t0 -> ponteiro para o vetor de entrada, que parte do in�cio do vetor
		# $t1 -> contador de n�meros processados
		# $t2 -> multiplicador que ser� utilizado na opera��o de verifica��o
		# $t3 -> armazena temporariamente o d�gito a ser manipulado
		# $t4 -> somat�rio das opera��es sobre os 9 primeiros d�gitos para comparar com o inserido no vetor de entrada
		# $t5 -> armazena os d�gitos de verifica��o inseridos no vetor para serem comparados com os obtidos pelos c�lculos
		# $t6 -> 0 se etiver verificando o primeiro d�gito verificador e 1 de estiver verificando o segundo
		# $t7 -> constante 11
		li $t2, 10 # inicia o multiplicador com 10
		li $t1, 1 # Inicia o contador de n�meros processados com 1, para realizar uma repeti��o a menos do loop na an�lise do primeiro d�gito verificador
		la $t6, ($zero)
		li $t7, 11 # Carrega 11 no registrador $t7
		verificaCPFRetorno:
			la $t0, ($a1) # Carrega no ponteiro o primeiro elemento do vetor de entrada
			la $t4, ($zero) # Inicia o registrador do somat�rio com 0
			loopVerificaCPF:
				lw $t3, ($t0) # Carrega em $t3 o d�gito apontado pelo ponteiro $t0
				addi $t1, $t1, 1 # Incrementa o contador de d�gitos processados em 1
				addi $t0, $t0, 4 # Incrementa o ponteiro para o pr�ximo n�mero do vetor
				mulo $t3, $t3, $t2 # Multiplica o valor do d�gito pelo multiplicador correspondente
				add $t4, $t4, $t3 # Soma ao total da opera��o de verifica��o o resultado das opera��es dessa itera��o do loopVerificaCPF
				subi $t2, $t2, 1 # Decrementa o multiplicador em 1
				ble $t1, 9, loopVerificaCPF # Enquanto o contador $t1 for menor ou igual � 9 repete o loopVerificaCPF
			lw $t5, ($t0) # Carrega o valor do primeiro d�gito de verifica��oe em $t5 para comparar com o somat�rio
			div $t4, $t7 # Divide o valor do somat�rio por 11
			mfhi $t4 # Armazena o resto da divis�o acima em $t4
			blt $t4, 2, digitoVerificadorMenorQ2VerificaCPF # Se o resultado de todas as opera��es for menor que 2 o primeiro d�gitp de verifica��o deve ser igual a 0
			sub $t4, $t7, $t4 # Subtrai o valor obtido de 11 e armazena em $t4
			bne $t4, $t5, falsoVerificaCPF # Se o valor do primeiro d�gito de verifica��o armazenado no vetor de entrada for diferete do resultado das opera��es em $t4 o CPF � falso
			beqz $t6, SegundoDigitoVerificadorVerificaCPF # Se o registrador $t6 fot igual � 0 deve se realizar a verifica��o do segundo d�gito
		la $v1, ($zero) # Se n�o a verifica��o foi concluida e o CPF est� correto, ent�o $v1 deve retornar 0
		jr $ra
		digitoVerificadorMenorQ2VerificaCPF:
			bne $t5, $zero, falsoVerificaCPF # Se o resulado das opera��es em $t4 for menor que 2 e o primeiro d�gito de verifica��o for diferente de 0 o CPF � falso
		SegundoDigitoVerificadorVerificaCPF:
			la $t2, ($t7) # Reinicia o multiplicador com 11
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o endere�o do segundo d�gito de verifica��o
			lw $t5, ($t0) # Carrega o valor do segundo d�gito de verifica��oe em $t5 para comparar com o somat�rio
			la $t1, ($zero) # Inicia o contador de n�meros processados com 0
			addi $t6, $t6, 1 # Incrementa o processador $t6 para 1
			j verificaCPFRetorno
		
		falsoVerificaCPF:
			li $v1, 1 # Carrefa 1 (FALSE) no registrador de retorno $v1
			jr $ra
		
			 
