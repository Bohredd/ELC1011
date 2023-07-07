.data
	valor1: .word 10
	valor2: .word 20
	string: .asciiz "fim!"
	mainS: .asciiz "main!"
	
	valorX: .asciiz "X: " 
	valorY: .asciiz "Y: " 
	linha: .asciiz " ------------------ "
	
	xmenor: .asciiz "if ( X < Y )"
	while: .asciiz " while ( X > Y )"
.text
.globl main

main:
	li $a1, 0 # Variavel N
	li $a2, 0 # Variavel M
	li $t0, 0 # Variavel RESULTADO
	
	addi $a1, $a1, 9 # N = 9;
	addi $a2, $a2, 20  # M = 20;
	
	jal procedimento1
	
	li $v0, 4
	la $a0, mainS
	syscall
	
	li $v0, 10
	syscall
	
procedimento1:
	move $s1, $ra # Salva o endereço de retorno para a main em $s0 
	addiu $sp, $sp, -40 # Cria o vetorA[10];
	li $t0, 0 # Variavel I
	li $t1, 0 # Variavel ACUMULADOR

	li $t2, 0 # Resultado para passar para vetorA[i]
	loopP1:
		mult $t0, $a1  # Multiplica X por I x
		
		mflo $t2 # Puxa o valor da multiplicação do I * X
		
		add $t2, $t2, $a2 # Soma o resultado de I * X com Y 
		
		sw $t2, 0($sp) # Salva em vetorA[i]
		
		move $s0, $t0
		
		jal procedimento2
		
		move $t0, $s0
		
		addi $t0, $t0, 1 # I++
		
		addiu $sp, $sp, 4 # Incrementa $sp para proxima posição do vetorA[i]
		
		li $v0, 11
		li $a0, 10 
		syscall
		
		li $v0, 11
		li $a0, 10 
		syscall
		
		bne $t0, 10, loopP1
		
		li $v0, 4
		la $a0, string
		syscall
		
	move $ra, $s1
	jr $ra
	
procedimento2:

	la $a0, linha
	li $v0, 4
	syscall
	
	li $v0, 11
	li $a0, 10
	syscall
	
	move $s3, $ra
	
	lw $t0, valor1 
	
	add $t5, $zero, $t2
	
	jal procedimento3
	
	move $t4, $v0

	li $v0, 11
	li $a0, 10
	syscall
	
	li $v0, 11
	li $a0, 10
	syscall

	move $t2, $t5
	
	lw $t0, valor2
	
	jal procedimento3
	
	#add $t1, $t1, $v0	
	#li $v0, 1
	#move $a0, $t4
	#syscall
	
	jr $s3
	
procedimento3:

	move $s4, $ra

	li $t4, 0 # Variavel tmp
	
	la $a0, valorX
	li $v0, 4
	syscall
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 11
	li $a0, 10
	syscall
	
	la $a0, valorY
	li $v0, 4
	syscall
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 11
	li $a0, 10
	syscall
	
	slt $t7, $t2, $t0
	
	beq $t7, 1, YmaiorX

	li $v0, 1
	move $a0, $t7
	syscall
	
	li $v0, 11
	li $a0, 10
	syscall
			
	slt $t7, $t0, $t2 
	
	move $a0, $t7
	
	li $v0, 1
	syscall
	
	li $v0, 11
	li $a0, 10
	syscall
	
	beq $t7, 1, whileXmaiorY
	
	jr $s4
	
YmaiorX:
	la $a0, xmenor
	li $v0, 4
	syscall
		
	move $t4, $t2
	move $t2, $t0
	move $t0, $t4
		
	jr $ra
		
whileXmaiorY:

	la $a0, while
	li $v0, 4
	syscall
	
	li $v0, 11
	li $a0, 10
	syscall
		
				
	jr $ra 
