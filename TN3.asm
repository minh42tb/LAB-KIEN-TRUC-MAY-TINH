.data
    n_val:   .word 20             
    str_f:   .asciiz "F("
    str_eq:  .asciiz ") = "
    newline: .asciiz "\n"

.text
.globl main

main:
    lw   $s0, n_val

    # de quy fib_rec(n)
    move $a0, $s0
    jal  fib_rec
    move $s1, $v0                 # luu ket qua F(n) vao $s1

    # in chuoi "F("
    li   $v0, 4
    la   $a0, str_f
    syscall

    # in gia tri n
    li   $v0, 1
    move $a0, $s0
    syscall

    # in chuoi ") = "
    li   $v0, 4
    la   $a0, str_eq
    syscall

    # in ket qua F(n)
    li   $v0, 1
    move $a0, $s1
    syscall

    li   $v0, 4
    la   $a0, newline
    syscall

    li   $v0, 10
    syscall

# fib_rec: tinh F(n) bang de quy

fib_rec:
    # neu n == 0 tra ve 0, neu n == 1 tra ve 1
    beq  $a0, $zero, fib_base_0
    li   $t0, 1
    beq  $a0, $t0, fib_base_1

    # cap phat khung ngan xep 12 bytes
    addi $sp, $sp, -12
    sw   $ra, 8($sp)
    sw   $s0, 4($sp)
    sw   $s1, 0($sp)

    move $s0, $a0                 # luu n vao $s0

    # goi de quy lan 1: F(n - 1)
    addi $a0, $s0, -1
    jal  fib_rec
    move $s1, $v0                 # luu ket qua F(n - 1) vao $s1

    # goi de quy lan 2: F(n - 2)
    addi $a0, $s0, -2
    jal  fib_rec

    # cong ket qua: F(n) = F(n - 1) + F(n - 2)
    addu $v0, $s1, $v0

    # khoi phuc thanh ghi va giai phong ngan xep
    lw   $s1, 0($sp)
    lw   $s0, 4($sp)
    lw   $ra, 8($sp)
    addi $sp, $sp, 12
    jr   $ra

fib_base_0:
    move $v0, $zero
    jr   $ra

fib_base_1:
    li   $v0, 1
    jr   $ra

# fib_iter: tinh F(n) bang vong lap (de doi chieu)
# Tham so : $a0 = n   Tra ve : $v0 = F(n)
# Thanh ghi: $t0-$t3 (thu tuc la)
fib_iter:
    move $v0, $zero               # a = F(0)
    li   $t0, 1                   # b = F(1)
    move $t1, $zero               # i = 0
fi_loop:
    slt  $t2, $t1, $a0
    beq  $t2, $zero, fi_done
    addu $t3, $v0, $t0            # a + b
    move $v0, $t0
    move $t0, $t3
    addiu $t1, $t1, 1
    j    fi_loop
fi_done:
    jr   $ra