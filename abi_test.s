	.file	"abi_test.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	x86_prime_factors
	.type	x86_prime_factors, @function
x86_prime_factors:
.LFB0:
	.cfi_startproc
	endbr64
	mov	QWORD PTR [rcx], 0
	mov	rax, rcx
	mov	BYTE PTR 8[rcx], 10
	ret
	.cfi_endproc
.LFE0:
	.size	x86_prime_factors, .-x86_prime_factors
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
