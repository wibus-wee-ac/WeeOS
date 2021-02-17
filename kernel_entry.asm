[bits 32]
[extern main] ; 像C一样，对外部函数得先声明。这个main就是kernel.c里面那个
call main     ; 执行
jmp $