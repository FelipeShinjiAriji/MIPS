.include "C:\Users\Felipe Shinji Ariji\Documents\ArquiteturaDeComputadores\Mars\macros.asm"

.data

	vetorInput: .space 1024
	vetorRetorno: .space 1024

.text

	Main:
		
		printString("Inisira a quantidade de n�meros a serem lidos: ")
		readInt
		la $a1, vetorInput
		la $a2, ($v0)
		jal lerFloats
		jal ordenaVetorCrescente
		jal printVetorFloat
		endProgram
	
	lerFloats: # Recebe o endere�o de um vetor para preencher em $a1 e l� a quantidade de n�meros floats do usu�rio equivalente ao valor recebido em $a2, salvando-os no vetor recebido
		# $t0 -> ponteiro para o pr�ximo espa�o vazio do vetor
		# $t1 -> contador de valores recebidos pelo usu�rio
		li $t1, 0 # Zera o registrador da quantidade de n�meros lidos $t1
		la $t0, ($a1) # Aponta o ponteiro $t0 para o primeiro espa�o livre do vetor
		loopLerFloats:
			printString("Insira o pr�ximo n�mero a ser inserido no vetor: ")
			readFloat
			addi $t1, $t1, 1 # incrementa a quantidade de n n�meros inteiros positivos lidos em $t1
			s.s  $f0, ($t0) # Armazena o valor recebido pelo usu�rio no pr�ximo espa�o vazio do vetor
			addi $t0, $t0, 4 # incrementa o ponteiro $t0 para o pr�ximo espa�o vazio do vetor
			blt $t1, $a2,  loopLerFloats # Enquanto o n�mero de elementos lidos for menor do que o valor recebido repete o loopLerFloats

		jr $ra
		
	ordenaVetorCrescente: # Recebe em $a1 o endere�o do vetor e em $a2 o seu comprimento e ordena-o de forma crescente
		li $t0, 1
		j Wnext001        
		Wbody001:                
			sll $t4, $t0, 2    
			add $t4, $a1, $t4  
			lw $t3, 0($t4)
			addi $t1, $t0, -1
			j Wnext002       
		Wbody002:           
			sll  $t4, $t1, 2
			add $t4, $a1, $t4
			lw $t2, 0($t4)
			addi $t4, $t4, 4
			sw $t2, 0($t4)
			addi $t1, $t1, -1
		Wnext002:
			blt $t1, $zero, Wdone002
			sll  $t4, $t1, 2    
			add $t4, $a1, $t4    
			lw $t2, 0($t4)     
			bgt $t2, $t3, Wbody002
		Wdone002:                      
			add  $t4, $t1, 1    
			sll  $t4, $t4, 2 
			add $t4, $a1, $t4
			sw $t3, 0($t4)         
			addi $t0, $t0, 1
		Wnext001: 
			blt $t0,$a2, Wbody001
		 
 		jr $ra
	
	printVetorFloat: #  Recebe o endere�o do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e imprime todos os n�meros do vetor
		# $t0 -> Ponteiro para o elemento atualmente avaliado
		# $t1 -> contador de n�meros impressos
		ble $a2, $zero, endPrintVetorFloat # Se o comprimento do vetor for menor ou igual a 0, a fun��o � cancelada
		la $t1, ($zero) # Inicia o contador de n�meros impressos $t1 com 0
		la $t0, ($a1) # Carrega em $t0 o endere�o do primeiro elemento do vetor 
		loopPrintVetorFloat:
			lw $t2, ($a1)		
			printFloat($t2)
			newline
			addi $t0, $t0, 4 # Incrementa o ponteiro para o pr�ximo elemento do vetor
			addi $t1, $t1, 1 # Incremenra o contador de n�meros impressos
			blt $t1, $a2, loopPrintVetorFloat # Enquanto o valor do contador de n�meros impressos for menor que o comprimento do vetor repete o loopPrintVetorFloat
		endPrintVetorFloat:
		jr $ra