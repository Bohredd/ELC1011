.data
	valor1: .word 10
	valor2: .word 20
	string: .asciiz "fim!"
	mainS: .asciiz "main!"
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
		
		li $v0, 1
		move $a0, $t2 
		syscall
		
		li $v0, 11
		li $a0, 10
		syscall
		
		jal procedimento2
		
		move $t0, $s0
		
		li $v0, 1
		move $a0, $t0
		syscall
		
		li $v0, 11
		li $a0, 10
		syscall
		
		addi $t0, $t0, 1 # I++
		
		addiu $sp, $sp, 4 # Incrementa $sp para proxima posição do vetorA[i]
		
		bne $t0, 10, loopP1
		
		li $v0, 4
		la $a0, string
		syscall
		
	move $ra, $s1
	jr $ra
	
procedimento2:
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 11
	li $a0, 10
	syscall
	
	jr $ra
