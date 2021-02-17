# WeeOS
First GUI OS By Wibus

自己做的第一个GUI系统

## How to Use?

你需要提前安装了 nasm 以及 QEMU

```bash
nasm -fbin bootsect.asm -o boot_sect.bin #编译文件
qemu-system-x86_64 boot_sect.bin #启动程序
```

## 学习历程

- 2021-2-17

  可以读取磁盘、输出字符串并换行