.data
    nhapx:   .asciiz "Nhap so kWh: "
    nhaplai:    .asciiz "Gia tri khong hop le, nhap lai.\n"
    res:     .asciiz "Tien dien: "
    tien:       .asciiz " dong\n"
    bac_max:      .word 6	#khai báo các mảng và bậc max
    limit:          .word 50, 100, 200, 300, 400, 9999
    price:          .word 1700, 1760, 2050, 2600, 2950, 3100

.text
.globl main

main:
loop:
    la      $a0, nhapx
    li      $v0, 4
    syscall
    
    li      $v0, 5
    syscall
    move    $s0, $v0	# $s0 = x

    sltiu   $t0, $s0, 10000
    bne     $t0, $zero, valid 

    la      $a0, nhaplai
    li      $v0, 4
    syscall
    j       loop

valid:
    li      $s1, 0	#tong tien=0   
    la      $s2, limit		#$s2 và s3 lưu địa chỉ cơ sở của 2 mảng
    la      $s3, price					              
    li      $s4, 0                 
    li      $s5, 0                  
    lw      $t4, bac_max	# $t4 = 6

calc_loop:
    beq     $s4, $t4, end      
    blez    $s0, end           

    # gán limit[c] và price[c]
    sll     $t1, $s4, 2            
    add     $t2, $s2, $t1
    lw      $t2, 0($t2)		# $t2 = limit[c]
    add     $t3, $s3, $t1
    lw      $t3, 0($t3)		 # $t3 = price[c]

    # dung tích tối đa của bậc hiện tại:
    sub     $t5, $t2, $s5	 # $t5 = capacity

    # xác định số kWh rơi vào bậc hiện tại:
    ble     $s0, $t5, remaining
    move    $t6, $t5               
    j       sum

remaining:
    move    $t6, $s0                

sum:
    mul     $t7, $t6, $t3           
    add     $s1, $s1, $t7	#cộng dồn tiền của từng bậc

    sub     $s0, $s0, $t6           
    move    $s5, $t2                

    addi    $s4, $s4, 1		#tăng lên bậc tiếp theo
    j       calc_loop


end:
    la      $a0, res #in kết quả rồi kết thúc chương trình
    li      $v0, 4
    syscall

    move    $a0, $s1
    li      $v0, 1
    syscall

    la      $a0, tien
    li      $v0, 4
    syscall

    li      $v0, 10
    syscall