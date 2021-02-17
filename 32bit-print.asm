[bits 32]

VIDEO_MEMORY equ 0xB8000 ; 这是VGA开始的地方
WHITE_ON_BLACK equ 0x0F  ; 是一个颜色代码，黑背景，白色字符

print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY

print_string_pm_loop:
    mov al, [ebx]          ; [ebx]是字符串参数
    mov ah, WHITE_ON_BLACK ; ah颜色参数

    cmp al, 0 ; 是不是已经到末尾？
    je print_string_pm_done ; 结束

    ; 如果不是
    mov [edx], ax ; 在Vram中保存字符
    add ebx, 1 ; 下一个字符
    add edx, 2 ; 下一个Vram字符位置，+2

    jmp print_string_pm_loop ; 递归

print_string_pm_done:
    popa
    ret