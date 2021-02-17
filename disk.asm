; 参数：
;   - dh：扇区个数
;   - dl：磁盘
; 读取的数据存入es:bx

disk_load:
    pusha              ; 压入栈
                       ; 将dx也压入栈
    push dx            ; dx一会会被读取磁盘的操作覆盖，所以先压入栈保存

    mov ah, 0x02       ; BIOS 读取扇区的功能编号
    mov al, dh         ; AL - 扇区读取个数，也就是我们的dh
    mov cl, 0x02       ; CL - 从哪里开始读取，因为第一个扇区是启动扇区，所以这里是0x02
    mov ch, 0x00       ; CH - 柱面编号(0x0-0x3FF)
    mov dh, 0x00       ; DH - 磁头编号(0x0-0xF)

    int 0x13           ; 读取磁盘的中断标号
    jc disk_error      ; Jump if Carry：如果CF被设置，就是出现了错误，跳转

    ; 如果没有错误
    pop dx             ; dx我们用完了，弹出栈
    cmp al, dh         ; 此时bios会把al设置为扇区个数，对比一下
    jne sectors_error  ; 如果两者不一样，读取扇区出现了错误，跳转
    popa               ; 如果一样，停止程序
    ret

; 剩下的是错误处理部分，大家都明白
disk_error:
    mov bx, DISK_ERROR
    call print
    call print_nl
    mov dh, ah
    call print_hex
    jmp disk_loop

sectors_error:
    mov bx, SECTORS_ERROR
    call print

disk_loop:
    jmp $

DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0