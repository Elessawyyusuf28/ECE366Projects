# ECE 366 Project 2
# Yusuf Elessawy, Husaam Khan, Salah El Hilo
# Part B - IsOdd

.data
m: .word 7
result: .word 0

.text
.globl main

main:
	lw $a0, m
	jal IsOdd
	nop
	sw $v0, result

	li $v0, 10
	syscall

IsOdd:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	
	li $a1, 2
	jal division
	nop

	beq $v0, $zero, return_odd
	nop
	li $v0, 1

return_odd:
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	nop

division:
	li $t0, 0

loop:
	blt $a0, $a1, done
	nop
	
	sub $a0, $a0, $a1
	addi $t0, $t0, 1
	j loop
	nop

done:
	move $v0, $a0
	jr $ra
	nop


