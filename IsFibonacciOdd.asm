# ECE 366 Project 2 - Final Report
# Yusuf Elessawy, Husaam Khan, Salah El Hilo

.data
n:      .word 10
result: .word 0

.text
.globl main
main:
    lw    $a0, n
    jal   IsFibonacciOdd
    nop
    sw    $v0, result

    li    $v0, 10
    syscall

# Compute Fibonacci(n), then check whether it is odd.
IsFibonacciOdd:
    addiu $sp, $sp, -8
    sw    $ra, 4($sp)

    jal   Fibonacci
    nop
    move  $a0, $v0
    jal   IsOdd
    nop

    lw    $ra, 4($sp)
    addiu $sp, $sp, 8
    jr    $ra
    nop

# Return Fibonacci(n) in $v0, with F(0) = 0 and F(1) = 1.
Fibonacci:
    ble   $a0, 1, fibonacci_base
    nop

    li    $t0, 0
    li    $t1, 1
    addiu $t2, $a0, -1

fibonacci_loop:
    beq   $t2, $zero, fibonacci_done
    nop

    move  $t3, $t1
    add   $t1, $t0, $t1
    move  $t0, $t3
    addiu $t2, $t2, -1
    j     fibonacci_loop
    nop

fibonacci_done:
    move  $v0, $t1
    jr    $ra
    nop

fibonacci_base:
    move  $v0, $a0
    jr    $ra
    nop

# The remainder modulo 2 is 0 for even or 1 for odd.
IsOdd:
    addiu $sp, $sp, -8
    sw    $ra, 4($sp)

    li    $a1, 2
    jal   division
    nop

    lw    $ra, 4($sp)
    addiu $sp, $sp, 8
    jr    $ra
    nop

# Return the remainder of $a0 / $a1 using repeated subtraction.
division:
    li    $t0, 0

division_loop:
    blt   $a0, $a1, division_done
    nop

    sub   $a0, $a0, $a1
    addiu $t0, $t0, 1
    j     division_loop
    nop

division_done:
    move  $v0, $a0
    jr    $ra
    nop
