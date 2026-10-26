.data
    scores:    .word 2, 5, 8, 10, 3, 7, 4, 9, 1, 6
    scores_len: .word 10

    grade_tab: .byte 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3

    hist:      .word 0, 0, 0, 0

    str_min:   .asciiz "min="
    str_max:   .asciiz " max="
    str_newline:.asciiz "\n"
    str_g0:    .asciiz "g0="
    str_g1:    .asciiz " g1="
    str_g2:    .asciiz " g2="
    str_g3:    .asciiz " g3="

.text
.globl main

main:
    la   $a0, scores
    lw   $a1, scores_len
    jal  stats
    
    move $s0, $v0
    move $s1, $v1

    la   $a0, scores
    lw   $a1, scores_len
    la   $a2, grade_tab
    la   $a3, hist
    jal  histogram

    li   $v0, 4
    la   $a0, str_min
    syscall

    li   $v0, 1
    move $a0, $s0
    syscall

    li   $v0, 4
    la   $a0, str_max
    syscall

    li   $v0, 1
    move $a0, $s1
    syscall

    li   $v0, 4
    la   $a0, str_newline
    syscall

    la   $t0, hist

    li   $v0, 4
    la   $a0, str_g0
    syscall
    li   $v0, 1
    lw   $a0, 0($t0)
    syscall

    li   $v0, 4
    la   $a0, str_g1
    syscall
    li   $v0, 1
    lw   $a0, 4($t0)
    syscall

    li   $v0, 4
    la   $a0, str_g2
    syscall
    li   $v0, 1
    lw   $a0, 8($t0)
    syscall

    li   $v0, 4
    la   $a0, str_g3
    syscall
    li   $v0, 1
    lw   $a0, 12($t0)
    syscall

    li   $v0, 10
    syscall

stats:
    lw   $v0, 0($a0)
    move $v1, $v0
    
    li   $t0, 1
    addi $t1, $a0, 4

stats_loop:
    beq  $t0, $a1, stats_done

    lw   $t2, 0($t1)

    bge  $t2, $v0, check_max
    move $v0, $t2

check_max:
    ble  $t2, $v1, stats_next
    move $v1, $t2

stats_next:
    addi $t0, $t0, 1
    addi $t1, $t1, 4
    j    stats_loop

stats_done:
    jr   $ra

histogram:
    li   $t0, 0
    move $t1, $a0

hist_loop:
    beq  $t0, $a1, hist_done

    lw   $t2, 0($t1)

    add  $t3, $a2, $t2
    lbu  $t4, 0($t3)

    sll  $t5, $t4, 2
    add  $t6, $a3, $t5
    
    lw   $t7, 0($t6)
    addi $t7, $t7, 1
    sw   $t7, 0($t6)

    addi $t0, $t0, 1
    addi $t1, $t1, 4
    j    hist_loop

hist_done:
    jr   $ra