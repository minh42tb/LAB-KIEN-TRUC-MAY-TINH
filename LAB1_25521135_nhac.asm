.data

    so_not:         .word 15
    cao_do:         .word 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 64, 62, 62
    do_dai:         .word  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  3,  1,  4

    # tham số cá nhân
    tham_so_a:      .word 5       # a = 5
    don_vi_nhip:    .word 180     # 150 + 10*b = 180 ms
    nhac_cu:        .word 73      
    am_luong:       .word 100     

    # chuỗi định dạng in ấn theo đúng đặc tả
    space:      .asciiz " "
    endl:    .asciiz "\n"
    dukien:     .asciiz "Tong du kien: "
    doduoc:     .asciiz "Thoi gian do duoc: "

.text
.globl main

main:
    la      $s0, cao_do         # $s0 = địa chỉ cơ sở mảng cao_do
    la      $s1, do_dai         # $s1 = địa chỉ cơ sở mảng do_dai
    lw      $s2, so_not         # $s2 = 15
    li      $s3, 0              # $s3 = chỉ số vòng lặp i
    li      $s4, 0              # $s4 = tổng thời lượng dự kiến (tự cộng dồn)

    li      $v0, 30
    syscall
    move    $s5, $a0            # $s5 = thời điểm bắt đầu 

loop_phat:
    beq     $s3, $s2, ket_thuc_phat  #chơi đủ thì dừng

    # lấy cao độ và độ dài của nốt thứ i (offset = i * 4)
    sll     $t0, $s3, 2
    add     $t1, $s0, $t0
    lw      $t1, 0($t1)         # $t1 = cao_do[i]

    add     $t2, $s1, $t0
    lw      $t2, 0($t2)         # $t2 = do_dai[i]

    # tính cao độ thực phát = cao_do[i] + a
    lw      $t3, tham_so_a
    add     $s6, $t1, $t3       # $s6 = <cao do> thực phát

    # tính thời lượng
    lw      $t4, don_vi_nhip
    mul     $s7, $t2, $t4       # $s7 = thời lượng của nốt

    # tự cộng dồn thời lượng nốt vào tổng dự kiến
    add     $s4, $s4, $s7

    # In <cao do>
    move    $a0, $s6
    li      $v0, 1
    syscall

    # In khoảng trắng " "
    la      $a0, space
    li      $v0, 4
    syscall

    # In <ms>
    move    $a0, $s7
    li      $v0, 1
    syscall

    # In xuống dòng "\n"
    la      $a0, endl
    li      $v0, 4
    syscall

    # Phát nốt bằng syscall 33
    move    $a0, $s6            # $a0 = pitch (cao độ thực phát)
    move    $a1, $s7            # $a1 = duration in ms
    lw      $a2, nhac_cu        # $a2 = instrument (73)
    lw      $a3, am_luong       # $a3 = volume (100)
    li      $v0, 33
    syscall

    # Tăng chỉ số nốt i++
    addi    $s3, $s3, 1
    j       loop_phat

ket_thuc_phat:
#phát bằng syscall 30 rồi thoát
    li      $v0, 30
    syscall
    sub     $t9, $a0, $s5       # $t9 = hiệu của hai lần đọc $a0 (thời gian đo được)

    la      $a0, dukien
    li      $v0, 4
    syscall

    move    $a0, $s4            # <so> tổng dự kiến đã cộng dồn
    li      $v0, 1
    syscall

    la      $a0, endl
    li      $v0, 4
    syscall

    la      $a0, doduoc
    li      $v0, 4
    syscall

    move    $a0, $t9            # <so> thời gian đo được
    li      $v0, 1
    syscall

    la      $a0, endl
    li      $v0, 4
    syscall

    li      $v0, 10
    syscall