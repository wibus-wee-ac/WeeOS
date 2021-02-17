gdt_start: ; 在这里写一个标签，待会用来计算大小

gdt_null:  ; 这个叫做空段，是Intel预留的
    dd 0   ; DD = double word  （此处也可以把两个dd合并为一个dq）
    dd 0   ;    = 4 byte

gdt_code: 
    dw 0xFFFF    ; Limit            0-15 bits
    dw 0         ; Base address     0-15
    db 0         ; 同上              16-23
    db 10011010B ; 按照图二Access Byte从右至左（0-7）的顺序填写。注意Privl因为值可以是0-3，所以说占两字节，填两个0
    db 11001111B ; 按图二flags从右至左填写。我们再看图一，flags右边还有limits最后4位，不满8位编译不通过，所以把limits合并在flags右面，0xF=0b1111
    db 0         ; Base             24-31

gdt_data:        ; 同上
    dw 0xFFFF
    dw 0
    db 0  
    db 10010010B ; 不同的是这里把Ex改成0，因为这里是数据段
    db 11001111B
    db 0

gdt_end:         ; gdt结束标签，

; GDT
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; 大小=结束-开始-1（真实大小永远-1）
    dd gdt_start               ; 开始地址

; 常量
CODE_SEG equ gdt_code - gdt_start ; CS
DATA_SEG equ gdt_data - gdt_start ; DS