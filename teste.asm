.include "C:\Users\Felipe Shinji Ariji\Documents\ArquiteturaDeComputadores\Mars\macros.asm"

.data

	Array:      .word   14, 12, 13, 5, 9, 11, 3, 6, 7, 10, 2, 4, 8, 1 

.text

Main:

	la $a1 Array
	li $a2, 14
	jal ordenaVetorCrescente
	newline
	jal printVetorIntReverso
	endProgram

	ordenaVetorCrescente: # Recebe em $a1 o endereço do vetor e em $a2 o seu comprimento e ordena-o de forma crescente
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
		
	 printVetorIntReverso: #  Recebe o endereço do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e imprime todos os números do vetor em ordem reversa
		# $t0 -> Ponteiro para o elemento atualmente avaliado
		# $t1 -> contador de números impressos
		# $t2 -> registrador auxiliar no processo de criar o ponteiro para o último elemento
		# $a0 -> Valor a ser impresso
		ble $a2, $zero, endPrintVetorIntReverso # Se o comprimento do vetor for menor ou igual a 0, a função é cancelada
		la $t1, ($zero) # Inicia o contador de números impressos $t1 com 0
		subi $t2, $a2, 1 # Carrega $t2 com o comprimento do vetor de entrada -1
		mulo $t2, $t2, 4 # Multiplica o comprimento do vetor de entrada por 4 para obter como resultado o espaço ocupado pelo vetor e salva em $t2
		add $t0, $a1, $t2 # Soma o valor do espaço de memória ocupado pelo vetor com o endereço do primeiro elemento para obter o endereço do último elemento e salva no ponteiro $t0
		loopPrintVetorIntReverso:
			lw $a0, ($t0) # Carrega em $a0 o valor a ser impresso
			printInt
			newline
			subi $t0, $t0, 4 # Decrementa o ponteiro para o elemento anterior do vetor
			addi $t1, $t1, 1 # Incremenra o contador de números impressos
			blt $t1, $a2, loopPrintVetorIntReverso # Enquanto o valor do contador de números impressos for menor que o comprimento do vetor repete o loopPrintVetorInt
		endPrintVetorIntReverso:
		jr $ra