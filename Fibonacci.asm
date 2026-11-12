# ECE 366 Project 2
# Yusuf Elessawy, Husaam Khan, Salah El Hilo
# Part A - Fibonacci

.data
n: .word 10
result: .word 0

.text
.globl main

main:
    lw $a0, n
    jal Fibonacci
    nop
    sw $v0, result

    li $v0, 10
    syscall

Fibonacci:
    # Check base case
    ble $a0, 1, base
    nop

    li $t0, 0       # a = 0
    li $t1, 1       # b = 1
    addi $t2, $a0, -1

loop:
    beq $t2, $zero, done
    nop

    move $t3, $t1       # temp = b
    add $t1, $t0, $t1   # b = a + b
    move $t0, $t3       # a = temp

    addi $t2, $t2, -1
    j loop
    nop

done:
    move $v0, $t1
    jr $ra
    nop

base:
    move $v0, $a0
    jr $ra
    nop