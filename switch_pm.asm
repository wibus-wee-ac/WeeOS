[bits 16] ; 代表在16位模式下。中括号可以去掉
switch_to_pm:
    cli                   ; 1. 一定要关掉CPU中断！让CPU专心干一件事
    lgdt [gdt_descriptor] ; 2. 还记得lgdt命令吗？加载我们的gdt_descriptor标签
    mov eax, cr0          ; 把cr0暂存到eax
    or eax, 0x1           ; 3. cr0设置为1，切到32位PM
    mov cr0, eax
    jmp CODE_SEG:init_pm  ; 4. 远跳转，跳到代码段（下面）

[bits 32] ; 32位！
init_pm:
    mov ax, DATA_SEG ; 5. 更新段寄存器
    mov ds, ax
    mov ss, ax
    mov es, ax  ; 把每个都刷一遍
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000 ; 6. 基址指针寄存器，其内存放着一个指针，该指针永远指向系统栈最上面一个栈帧的底部，把它放到0x90000，待会加载内核
    mov esp, ebp

    call BEGIN_PM ; 跳到bootsect