print:
    pusha ; 将所有东西压入栈

; 记住：一直循环打印栈的字符，直到碰到字符串末0x0
; while (string[i] != 0) { print string[i]; i++ }

start:
    mov al, [bx] ; bx相当于字符串参数，是字符串的首位
    cmp al, 0    ; al和0比较
    je done      ; 如果相等，就到了字符串末尾，跳转到结束done

    mov ah, 0x0E ; 如果不相等，开始打印，先进入tty模式
    int 0x10     ; 直接中断。因为al参数已经有字符了

    add bx, 1    ; 如果你把这个栈+1，相当于地址后移一位，这样再打印就是下一个字符串
    jmp start    ; 递归

done:
    popa         ; 弹出栈
    ret          ; 返回主程序
    

print_nl:        ; print NewLine
    pusha

    mov ah, 0x0E ; tty模式
    mov al, 0x0A ; 把0x0A和0x0D合起来相当于\n
    int 0x10
    mov al, 0x0D ; 把0x0A和0x0D合起来相当于\n
    int 0x10

    popa
    ret

print_hex:
    pusha
    mov cx, 0 ; cx在循环指令和重复前缀中，作循环次数计数器

; 参数dx：要打印的地址
hex_loop:
    cmp cx, 4 ; cx是不是已经循环了四次？
    je end    ; 如果是，跳转到end结束

    ; 如果不是：开始处理

    mov ax, dx     ; 在ax上对字符处理，（dx是我们的地址参数）
    and ax, 0x000F ; 先把这个地址只保留最后一位。比如0x1234就变成0x0004
    add al, 0x30   ; 加上30，这样4就会变成ASCII：34（别忘了这个al是ax的一部分，是一个寄存器——
    cmp al, 0x39   ; 如果发现这个数字>9，不是0～9，那么这个数字就是字母，加上7，就会是A~F中的一个
    jle step2      ; Jump if Lower or Equal：al小于等于0x39跳转至step2
    add al, 7

step2:
    ; 第二步：我们的ASCII字符应该放在哪个地址呢？
    ; 地址BX：基地址+字符串长度（5位，别忘了还有最后的0x0）-字符索引
    mov bx, HEX_OUT + 5 ; 基+长
    sub bx, cx          ; -索引
    mov [bx], al        ; 把al中的字符移到[bx]，中括号表示地址的内容
    ror dx, 4           ; ROll Right：0x1234 -> 0x4123 -> 0x3412 -> 0x2341 -> 0x1234. ror帮我们实现类似遍历字符串的效果。你可以去掉这行指令，看看会发生什么

    add cx, 1           ; 循环计数器+1
    jmp hex_loop        ; 回到循环

end:
    mov bx, HEX_OUT     ; 把HEX_OUT设置到bx里，作为下一个call的参数
    call print          ; 调用写好的print.asm

    popa
    ret

HEX_OUT:
    db '0x0000', 0 ; 这是我们输出的地址，先定义下来
