[org 0x7c00]
KERNEL_OFFSET equ 0x1000 ; 定义常量，这个常量是内核的位置

    mov [BOOT_DRIVE], dl ; BIOS会自动把磁盘编号设置到dl。我们在下面间一个常量，先存起来，因为dl可能会被覆盖
    mov bp, 0x9000
    mov sp, bp

    mov bx, MSG_REAL_MODE ; 实模式打印
    call print
    call print_nl

    call load_kernel  ; 加载内核
    call switch_to_pm ; 切PM

%include "disk.asm"
%include "gdt.asm"
%include "print.asm"
%include "switch_pm.asm"
%include "32bit-print.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print
    call print_nl

    mov bx, KERNEL_OFFSET ; 读取到内核偏移地址
    mov dh, 2
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm
    call KERNEL_OFFSET ; 执行内核代码
    jmp $

BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0

times 510 - ($-$$) db 0
dw 0xAA55