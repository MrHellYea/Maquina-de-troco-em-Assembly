.data
	bills: .word 10000, 5000, 2000, 1000, 500, 200  # Notas possíveis
	coins: .word 100, 50, 25, 10, 5, 1  # Moedas possíveis
	msg_bills: .asciiz " notas de R$"
	msg_coins: .asciiz " moedas de R$"
	msg_comma: .asciiz ","
	msg_zero: .asciiz "0"
	newline: .asciiz "\n"

.text

.globl main
main:
	li $s0, 10000  # Valor pago (R$100,00)
	li $s1, 7999  # Preço (R$79,99)
	sub $s2, $s0, $s1  # Calcula o troco
	li $s3, 0  # Iterador
	li $s4, 6  # Quantidade de elementos dos arrays
	li $s6, 100
	li $s7, 10
	
	la $s5, bills  # Endereço do array bills
	LOOP:  # For loop
		slt $t0, $s3, $s4  # t0 = 0 se s3 >= s4. senão t0 = 1
		beq $t0, $zero, EXIT  # Termina o loop se t0 = 0
		
		add $t1, $s3, $s3  # Multipla s3 por 2
		add $t1, $t1, $t1  # Multipla s3 por 2 de novo
		add $t1, $s5, $t1  # Armazena em t1 o endereço do índice
		lw $t1, 0 ($t1)  # Lê e armazena o valor do índice
		
		div $s2, $t1  # Divide s2 por t1
		mflo $t2  # Quociente
		mfhi $s2  # Resto
		
		li $v0, 1  # Prepara o print de um inteiro
		la $a0, ($t2)  # Carrega o inteiro
		syscall  # Printa
		
		li $v0, 4  # Prepara o print de uma string
		la $a0, msg_bills  # Carrega a string
		syscall
		
		div $t1, $s6  # Divide o valor da nota por 100
		mflo $t1

		li $v0, 1
		la $a0, ($t1)
		syscall
		
		li $v0, 4
		la $a0, newline
		syscall
		
		addi $s3, $s3, 1  # s3 += 1
		j LOOP  # Volta pro início do loop
		EXIT:
			
	beq $s2, $zero, END  # Se troco(s2) = 0, termina, senão, roda o For de moedas
	li $s3, 0  # Redefine o iterador para 0
	la $s5, coins  # Endereço do array coins
	LOOP2:
		slt $t0, $s3, $s4
		beq $t0, $zero, EXIT2
		
		add $t1, $s3, $s3
		add $t1, $t1, $t1
		add $t1, $s5, $t1
		lw $t1, 0 ($t1)
		
		div $s2, $t1
		mflo $t2
		mfhi $s2
		
		li $v0, 1
		la $a0, ($t2)
		syscall
		
		li $v0, 4
		la $a0, msg_coins
		syscall
		
		beq $t1, $s6, print1  # Se t1 = 100, pula pra print1
		
		slt $t2, $t1, $s7  # Se o caso acima não rodar e se t1 >= 10, t2 = 0
		beq $t2, $zero, print2  # Se t2 = 0, pula pra print2
		
		j print3  # Se nenhum dos casos acima rodar, pula para print3
		
		print1:
			div $t1, $s6
			mflo $t1

			li $v0, 1
			la $a0, ($t1)
			syscall
			j after_print  # Pula para depois dos outros prints
		
		print2:
			li $v0, 4
			la $a0, msg_zero
			syscall  # Printa o caracter 0

			la $a0, msg_comma
			syscall  # Printa o caracter vírgula (,)
			
			li $v0, 1
			la $a0, ($t1)
			syscall  # Printa o número de dois dígitos
			j after_print

		print3:
			li $v0, 4
			la $a0, msg_zero
			syscall  # Printa o caracter 0

			la $a0, msg_comma
			syscall  # Printa o caracter vírgula (,)
			
			la $a0, msg_zero
			syscall  # Printa o caracter 0
			
			li $v0, 1
			la $a0, ($t1)
			syscall  # Printa o número de um dígito
		
		after_print:
		
		li $v0, 4
		la $a0, newline
		syscall
		
		addi $s3, $s3, 1
		j LOOP2
		EXIT2:
	END:
