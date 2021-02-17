[org 0x7C00]
mov bp, 0x8000 ; 把栈顶设成0x8000，这样不与BIOS相干
mov sp, bp     ; 同上
mov bx, 0x9000 ; es:bx == 0x0000:0x9000 == 0x09000

; 现在我们要设置disk_load参数
mov dh, 2 ; 读取两个扇区
; 此处不用设置dl，BIOS已经帮我们设置过了
call disk_load ; 调用

mov dx, [0x9000] ; 获取第一扇区
call print_hex
call print_nl

mov dx, [0x9000 + 512] ; 获取第二扇区（注意偏移地址，跟下面数据对应）
call print_hex

jmp $

%include "print_hex.asm"
%include "disk.asm"

times 510 - ($-$$) db 0
dw 0xAA55

; 上面是bs（第一个扇区）
times 256 dw 0x1234 ; 第2
times 256 dw 0x5678 ; 第3
; 上面的第二第三也不一定，因为有的磁盘一个扇区512，现在有的4096
; …………