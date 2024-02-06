.data
	txt00: .asciiz "Informe o valor da chave k: "
	txt01: .asciiz "Tamanho do vetor: "
	txt02: .asciiz "Insira o valor do array["
	txt03: .asciiz "]: "
	txt04: .asciiz "vetor[] = {"
	txt05: .asciiz ","
	txt06: .asciiz "}"
	array: .align 2
.text
	main:
		jal receiveSize
		jal receiveKey
		la $a0, array	# endereço do array como parametro
		jal receiveValues
		jal printArray
		jal rotateRight
		jal printArray
		
		li $v0, 10	# código para finalizar o programa
		syscall		# finaliza o programa
	
	receiveSize:
		li $v0, 4	# código para impressão de string
		la $a0, txt01	# carrega o endereço da string
		syscall		# impressão da string
		li $v0, 5	# código de leitura de um inteiro
		syscall		# leitura do valor
		move $s0, $v0	# armazena o número em $s0 = n (tamanho do vetor)
		jr $ra		# retorna para main
		
	receiveKey:
		li $v0, 4	# código para impressão de string
		la $a0, txt00	# carrega o endereço da string
		syscall		# impressão da string
		li $v0, 5	# código de leitura de um inteiro
		syscall		# leitura do valor
		move $s1, $v0	# armazena o número em $
		jr $ra		# retorna para main
	
	receiveValues:
		move $t0, $a0		# salva o endereço base do array
		move $t1, $t0		# endereço do array[i]
		li $t2, 0		# i = 0
	L:	la $a0, txt02		# carrega o endereço da string
		li $v0, 4		# código da impressão da string
		syscall			# impressão de string
		move $a0, $t2		# carrega o indice de vetor
		li $v0, 1		# código de impressão de inteiro
		syscall			# imprime o indice i
		la $a0, txt03 		# carrega o endereço da string
		li $v0, 4		# código da impressão da string
		syscall			# impressão de string
		li $v0, 5		# código de leitura de inteiro
		syscall			# leitura do valor
		sw $v0, ($t1) 		# salva o valor lido em vet[i]
		add $t1, $t1, 4		# endereço de vet[i + 1]
		addi $t2, $t2, 1	# i++
		blt $t2, $s0, L		# if (i < n) go to l	- n -> tamanho do vetor
		jr $ra			# retorna para a main
		
	rotateRight:
		move $t5, $s1		# $t5 indice para o loop, enquanto $t5 menor que a chave k
	start:	move $t1, $t0		# endereço do array[i]
		move $t3, $t1		# $t3 salva o endereço do array[i]
		add $t3, $t3, 4		# endereço de vet[i + 1] <- auxiliar
		li $t2, 0		# i = 0
		li $t4, 1		# j = 1
	loop:	
		lw $s2, ($t1)		# $s2 = array[i]
		lw $s3, ($t3)		# $s3 = array[i + 1]
		sw $s2, ($t3)
		move $s3, $s2
		beq $t4, $s0, first
		
		add $t2, $t2, 1
		add $t4, $t4, 1
		blt $t2, $s0, loop		# if (i < n) go to l	- n -> tamanho do vetor
	exit:
		subi $t5, $t5, 1
		beq $t5, $zero, end
		j start
	end:	
		jr $ra
		
	first:
		sw $s2, ($t0)
		j exit
		
	printArray:
		li $t2, 0
		li $t4, 0
		move $t1, $t0
		li $v0, 4	# código para impressão de string
		la $a0, txt04	# carrega o endereço da string
		syscall		# impressão da string
		loopI:
			li $v0, 1
			lw $a0, ($t1)
			syscall			# imprime o indice i
			add $t1, $t1, 4		# endereço de vet[i + 1]
			addi $t2, $t2, 1	# i++
			addi $t4, $t4, 1
			bne $t4, $s0, comma
		r:	
			blt $t2, $s0, loopI	# if (i < n) go to l	- n -> tamanho do vetor
		endI:
		li $v0, 4	# código para impressão de string
		la $a0, txt06	# carrega o endereço da string
		syscall		# impressão da string
		jr $ra
	
	comma:
		li $v0, 4	# código para impressão de string
		la $a0, txt05	# carrega o endereço da string
		syscall		# impressão da string
		j r
