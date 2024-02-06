.include "C:\Users\Felipe Shinji Ariji\Documents\ArquiteturaDeComputadores\Mars\macros.asm"

.data

	vetorInput: .space 1024
	vetorRetorno: .space 1024

.text

	Main:
		
		printString("Inisira a quantidade de números a serem lidos: ")
		readInt
		la $a1, vetorInput
		la $a2, ($v0)
		jal lerFloats
		jal ordenaVetorCrescente
		jal printVetorFloat
		endProgram
	
	lerFloats: # Recebe o endereço de um vetor para preencher em $a1 e lê a quantidade de números floats do usuário equivalente ao valor recebido em $a2, salvando-os no vetor recebido
		# $t0 -> ponteiro para o próximo espaço vazio do vetor
		# $t1 -> contador de valores recebidos pelo usuário
		li $t1, 0 # Zera o registrador da quantidade de números lidos $t1
		la $t0, ($a1) # Aponta o ponteiro $t0 para o primeiro espaço livre do vetor
		loopLerFloats:
			printString("Insira o próximo número a ser inserido no vetor: ")
			readFloat
			addi $t1, $t1, 1 # incrementa a quantidade de n números inteiros positivos lidos em $t1
			s.s  $f0, ($t0) # Armazena o valor recebido pelo usuário no próximo espaço vazio do vetor
			addi $t0, $t0, 4 # incrementa o ponteiro $t0 para o próximo espaço vazio do vetor
			blt $t1, $a2,  loopLerFloats # Enquanto o número de elementos lidos for menor do que o valor recebido repete o loopLerFloats

		jr $ra
		
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
	
	printVetorFloat: #  Recebe o endereço do primeiro elemento do vetor em $a1 e o comprimento do vetor em $a2 e imprime todos os números do vetor
		# $t0 -> Ponteiro para o elemento atualmente avaliado
		# $t1 -> contador de números impressos
		ble $a2, $zero, endPrintVetorFloat # Se o comprimento do vetor for menor ou igual a 0, a função é cancelada
		la $t1, ($zero) # Inicia o contador de números impressos $t1 com 0
		la $t0, ($a1) # Carrega em $t0 o endereço do primeiro elemento do vetor 
		loopPrintVetorFloat:
			lw $t2, ($a1)		
			printFloat($t2)
			newline
			addi $t0, $t0, 4 # Incrementa o ponteiro para o próximo elemento do vetor
			addi $t1, $t1, 1 # Incremenra o contador de números impressos
			blt $t1, $a2, loopPrintVetorFloat # Enquanto o valor do contador de números impressos for menor que o comprimento do vetor repete o loopPrintVetorFloat
		endPrintVetorFloat:
		jr $ra