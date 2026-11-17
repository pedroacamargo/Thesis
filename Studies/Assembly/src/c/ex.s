	.file	"ex.c"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr64	
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	subq	$32, %rsp	#,
# ex.c:3: int main(void) {
	movq	%fs:40, %rax	# MEM[(<address-space-1> long unsigned int *)40B], tmp100
	movq	%rax, -8(%rbp)	# tmp100, D.3521
	xorl	%eax, %eax	# tmp100
# ex.c:4:     char ola[] = "Hello, World!\n";
	movabsq	$6278066737626506568, %rax	#, tmp105
	movq	%rax, -23(%rbp)	# tmp105, ola
	movabsq	$2851464966991703, %rax	#, tmp106
	movq	%rax, -16(%rbp)	# tmp106, ola
# ex.c:5:     write(STDOUT_FILENO, &ola, sizeof(ola));
	leaq	-23(%rbp), %rax	#, tmp101
	movl	$15, %edx	#,
	movq	%rax, %rsi	# tmp101,
	movl	$1, %edi	#,
	call	write@PLT	#
# ex.c:6:     return 0;
	movl	$0, %eax	#, _4
# ex.c:7: }
	movq	-8(%rbp), %rdx	# D.3521, tmp103
	subq	%fs:40, %rdx	# MEM[(<address-space-1> long unsigned int *)40B], tmp103
	je	.L3	#,
	call	__stack_chk_fail@PLT	#
.L3:
	leave	
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 15.2.0-16ubuntu1) 15.2.0"
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
