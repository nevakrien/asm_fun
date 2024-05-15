#bash
nasm -f elf64 primes.asm 
gcc wrapper.c primes.o -O3 -no-pie
./a.out 
