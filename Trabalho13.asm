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

.macro readString(%inputAddress, %maxCharacters) # Lê uma String com número máximo de characteres fornecidos no segundo argumento e salva-a no endereço fornecido no primeiro argumento
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
			printString("O CPF inserido é inválido.")
			endProgram
		CPFvalido:
			printString("O CPF inserido é válido.")
			endProgram
		
	stringCPFToIntVector: # Recebe em $a1 o endereço do primeiro elemento de uma String de CPF no formato "111111111-11" e cria um vetor de inteiros no endereço recebido em $a2
		# :$t0 -> ponteiro para o caracter da String atualmente processado
		# $t1 -> caracter da String atualmente processado
		# $t2 -> ponteiro para o próximo elemento vazio do vetor de retorno
		# $t3 -> Auxiliar que armazena temporariamente o inteiro a ser armazenado no vetor 
		# $t4 -> contador da quantidade de dígitos convertido de String para int
		la $t0, ($a1) # Carrega no ponteiro o endereço do primeiro caracter da String a ser convertida
		la $t2, ($a2) # Carrega no ponteiro o endereço do primeiro elemento vazio do vetor de retorno
		la $t4, ($zero) # Inicia o contador $t4 com 0
		loopStringCPFToIntVector:
			lb $t1, ($t0) # Carrega em $t1 o caracter da String apontado pelo ponteiro $t0
			addi $t0, $t0, 1 # Incrementa o ponteiro para a String de entrada $t0, para o próximo caracter
			addi $t4, $t4, 1 # Incrementa em 1 o contador da quantidade de dígitos convertido de String para int $t4
			bne $t4, 10, numberDigitStringCPFToIntVector # Se a quantidade de dígitos do número sendo convertido atualmente de String para int em $t6 não for igual à 10 não se deve realisar a linha abaixo
				bne $t1, 45, errorStringCPFToIntVector # Se o valor de $t1 não for 45 significa que o 10 dígito não é um traço portanto o formato está errado, nesse caso gera mensagem de erro e finaliza o programa
				j loopStringCPFToIntVector
			numberDigitStringCPFToIntVector:
				ble $t1, 47, errorStringCPFToIntVector # Se o valor na tabaela ASCII for menor ou igual à 47 não é um dígito numérico então acontece um erro na função
				bge $t1, 58, errorStringCPFToIntVector # Se o valor na tabaela ASCII for maior ou igual à 58 não é um dígito numérico então acontece um erro na função
				subi $t3, $t1, 48 # Subtrai 48 do valor armazenado em $t1, para converter de valor de tabela ASCII para o valor numérico normal e salva em $t3  
				sw $t3, ($t2) # Salva o valor armazenado em $t3 como int no endereço apontado por $t2
				addi $t2, $t2, 4 # Incrementa o ponteiro para $t2 para o próximo elemento vazio do vetor de retorno
				ble $t4, 11, loopStringCPFToIntVector # Enquanto o valor do contador $t4 for menor ou igual à 12 repete o loopStringCPFToIntVector
		jr $ra
		errorStringCPFToIntVector:
			printString("Error: CPF inserido é inválido.")
			endProgram
		
	verificaCPF: # Recebe o endereço do primeiro elemento de um vetor de inteiros correspondentes aos dígitos numéricos de um CPF em $a1 e retorna em $v1 0 se os bits de verificação estiverem corretos e 1 caso contrário
		# $t0 -> ponteiro para o vetor de entrada, que parte do início do vetor
		# $t1 -> contador de números processados
		# $t2 -> multiplicador que será utilizado na operação de verificação
		# $t3 -> armazena temporariamente o dígito a ser manipulado
		# $t4 -> somatório das operações sobre os 9 primeiros dígitos para comparar com o inserido no vetor de entrada
		# $t5 -> armazena os dígitos de verificação inseridos no vetor para serem comparados com os obtidos pelos cálculos
		# $t6 -> 0 se etiver verificando o primeiro dígito verificador e 1 de estiver verificando o segundo
		# $t7 -> constante 11
		li $t2, 10 # inicia o multiplicador com 10
		li $t1, 1 # Inicia o contador de números processados com 1, para realizar uma repetição a menos do loop na análise do primeiro dígito verificador
		la $t6, ($zero)
		li $t7, 11 # Carrega 11 no registrador $t7
		verificaCPFRetorno:
			la $t0, ($a1) # Carrega no ponteiro o primeiro elemento do vetor de entrada
			la $t4, ($zero) # Inicia o registrador do somatório com 0
			loopVerificaCPF:
				lw $t3, ($t0) # Carrega em $t3 o dígito apontado pelo ponteiro $t0
				addi $t1, $t1, 1 # Incrementa o contador de dígitos processados em 1
				addi $t0, $t0, 4 # Incrementa o ponteiro para o próximo número do vetor
				mulo $t3, $t3, $t2 # Multiplica o valor do dígito pelo multiplicador correspondente
				add $t4, $t4, $t3 # Soma ao total da operação de verificação o resultado das operações dessa iteração do loopVerificaCPF
				subi $t2, $t2, 1 # Decrementa o multiplicador em 1
				ble $t1, 9, loopVerificaCPF # Enquanto o contador $t1 for menor ou igual à 9 repete o loopVerificaCPF
			lw $t5, ($t0) # Carrega o valor do primeiro dígito de verificaçãoe em $t5 para comparar com o somatório
			div $t4, $t7 # Divide o valor do somatório por 11
			mfhi $t4 # Armazena o resto da divisão acima em $t4
			blt $t4, 2, digitoVerificadorMenorQ2VerificaCPF # Se o resultado de todas as operações for menor que 2 o primeiro dígitp de verificação deve ser igual a 0
			sub $t4, $t7, $t4 # Subtrai o valor obtido de 11 e armazena em $t4
			bne $t4, $t5, falsoVerificaCPF # Se o valor do primeiro dígito de verificação armazenado no vetor de entrada for diferete do resultado das operações em $t4 o CPF é falso
			beqz $t6, SegundoDigitoVerificadorVerificaCPF # Se o registrador $t6 fot igual à 0 deve se realizar a verificação do segundo dígito
		la $v1, ($zero) # Se não a verificação foi concluida e o CPF está correto, então $v1 deve retornar 0
		jr $ra
		digitoVerificadorMenorQ2VerificaCPF:
			bne $t5, $zero, falsoVerificaCPF # Se o resulado das operações em $t4 for menor que 2 e o primeiro dígito de verificação for diferente de 0 o CPF é falso
		SegundoDigitoVerificadorVerificaCPF:
			la $t2, ($t7) # Reinicia o multiplicador com 11
			addi $t0, $t0, 4 # Incrementa o ponteiro $t0 para o endereço do segundo dígito de verificação
			lw $t5, ($t0) # Carrega o valor do segundo dígito de verificaçãoe em $t5 para comparar com o somatório
			la $t1, ($zero) # Inicia o contador de números processados com 0
			addi $t6, $t6, 1 # Incrementa o processador $t6 para 1
			j verificaCPFRetorno
		
		falsoVerificaCPF:
			li $v1, 1 # Carrefa 1 (FALSE) no registrador de retorno $v1
			jr $ra
		
			 
