.data
    str1:    .asciiz "kien truc may tinh"
    str2:    .asciiz "mips"
    str3:    .asciiz ""
    str4:    .asciiz "a bc def"
    str_sd:  .asciiz "dao chuoi tai cho tiet kiem bo nho"
    pipe:    .asciiz "|"
    newline: .asciiz "\n"

.text
.globl main

main:
    la   $a0, str1
    jal  run_test

    la   $a0, str2
    jal  run_test

    la   $a0, str3
    jal  run_test

    la   $a0, str4
    jal  run_test

    la   $a0, str_sd
    jal  run_test

    # Ket thuc chuong trinh
    li   $v0, 10
    syscall

# Thu tuc phu in ket qua theo dinh dang |<chuoi>|
run_test:
    addi $sp, $sp, -8
    sw   $ra, 4($sp)
    sw   $a0, 0($sp)

    jal  reverse_words

    # In dau '|' mo dau
    li   $v0, 4
    la   $a0, pipe
    syscall

    # In chuoi da dao
    li   $v0, 4
    lw   $a0, 0($sp)
    syscall

    # In dau '|' ket thuc va xuong dong
    li   $v0, 4
    la   $a0, pipe
    syscall
    la   $a0, newline
    syscall

    lw   $ra, 4($sp)
    addi $sp, $sp, 8
    jr   $ra


strlen:
    move $t0, $a0
strlen_loop:
    lbu  $t1, 0($t0)
    beq  $t1, $zero, strlen_done
    addi $t0, $t0, 1
    j    strlen_loop
strlen_done:
    subu $v0, $t0, $a0
    jr   $ra


rev_range:
    bgeu $a0, $a1, rev_done
    lbu  $t0, 0($a0)
    lbu  $t1, 0($a1)
    sb   $t1, 0($a0)
    sb   $t0, 0($a1)
    addi $a0, $a0, 1
    addi $a1, $a1, -1
    j    rev_range
rev_done:
    jr   $ra

reverse_words:
    addi $sp, $sp, -20
    sw   $ra, 16($sp)
    sw   $s0, 12($sp)
    sw   $s1, 8($sp)
    sw   $s2, 4($sp)
    sw   $s3, 0($sp)

    move $s0, $a0            # $s0 = dia chi dau chuoi

    jal  strlen              # $v0 = do dai chuoi
    beq  $v0, $zero, rw_exit 

    # Dao toan bo chuoi [$s0, $s1]
    addu $s1, $s0, $v0
    addi $s1, $s1, -1

    move $a0, $s0
    move $a1, $s1
    jal  rev_range

    # Quet tung ky tu de dao lai tung tu
    move $s2, $s0            # $s2 = con tro duyet
    move $s3, $s0            # $s3 = dau tu hien tai
    li   $t2, 32             

rw_scan_loop:
    bgtu $s2, $s1, rw_last_word
    lbu  $t0, 0($s2)
    bne  $t0, $t2, rw_next_char

    move $a0, $s3
    addi $a1, $s2, -1
    jal  rev_range

    addi $s3, $s2, 1

rw_next_char:
    addi $s2, $s2, 1
    j    rw_scan_loop

rw_last_word:
    move $a0, $s3
    move $a1, $s1
    jal  rev_range

rw_exit:
    lw   $s3, 0($sp)
    lw   $s2, 4($sp)
    lw   $s1, 8($sp)
    lw   $s0, 12($sp)
    lw   $ra, 16($sp)
    addi $sp, $sp, 20
    jr   $ra
