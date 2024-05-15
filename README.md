# asm_fun
doing fun assembly stuff
>nasm -f win64 primes.asm -o primes.obj

on linux
nasm -f elf64 primes.asm
gcc wrapper.c primes.o -no-pie