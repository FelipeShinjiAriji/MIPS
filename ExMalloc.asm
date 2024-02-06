.text
		
	malloc:		
		li $a0, 4 # 4 bytes (Inteiro)
		li $v0, 9 # Código de alocação dinâmica heap
		syscall # Aloca 4 bytes (Endereço em $v0)
		move $t0, $v0 # Move para $t0
		li $t1, 3 # aux = 3
		sw $t1, ($t0) # *n = 3
		li $a0, 40 # 40 bytes (Espaço para 10 inteiros)
		li $v0, 9 # Código de alocação dinâmica heap
		syscall # Aloca 40 bytes
		move $t1, $v0 # Move para $t1
		li $t2, 7 # aux = 7
		sw $t2, ($t1) # v[0] = 7
		li $t2, 11 # aux = 11
		sw $t2, 12($t1) # v[3] = 11
		li $t2, 34 # aux = 34
		sw $t2, 32($t1) # v[8] = 34
		li $a0, 20 # 20 bytes (Espaço para 20 character)
		li $v0, 9 # Código de alocação dinâmica heap
		syscall # Aloca 20 bytes
		move $a0, $v0 # Endereço base da String
		li $a1, 20 # Número máximo de caracteres
		li $v0, 8 # Código para leitura de String
		syscall # scanf ("%s", s)