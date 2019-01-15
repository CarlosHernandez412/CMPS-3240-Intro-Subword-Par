	.file	"myblas.c"
	.text
	.globl	dewvm
	.type	dewvm, @function
dewvm:                              ; Start of DEWVM function
.LFB0:
	.cfi_startproc
	pushq	%rbp                    ; Start of setting up the stack
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)         ; Holds 'N', length of arrays
	movq	%rsi, -32(%rbp)         ; Address spacing is unusual, must be due to OS or ...
	movq	%rdx, -40(%rbp)         ; ... calling convention. Just leave this as is.
	movq	%rcx, -48(%rbp)
	movl	$0, -4(%rbp)            ; 'i' counter located at -4(%rbp)
	jmp	.L2                         ; Note that 'jmp' is unconditional
.L3:                                
	movl	-4(%rbp), %eax          ; %eax = 0, presumably this is 'i'
	cltq                            ; Unoptimized, promotes i to a 64 bit int
	leaq	0(,%rax,8), %rdx        ; The way to read memory addresses is 
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-32(%rbp), %rdx
	addq	%rcx, %rdx
	movsd	(%rdx), %xmm1
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-40(%rbp), %rdx
	addq	%rcx, %rdx
	movsd	(%rdx), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, -4(%rbp)            ; i++
.L2:
    ; Shadow 'i' into %eax because 'cmpl' cannot take two memory addresses.
	movl	-4(%rbp), %eax

    ; Now carry out the comparison to 'N'.
	cmpl	-20(%rbp), %eax         ; i < N?
	jl	.L3                         ; ... if so, go to back loop body at .L3

    ; Block to leave and return 0
	movl	$0, %eax                ; 0 in return register (Executed OK)

    ; Pop the stack. Note that 'leave' is only used when returning from main().
	popq	%rbp                    

	.cfi_def_cfa 7, 8
	ret                             ; Then return.
	.cfi_endproc

.LFE0:
	.size	dewvm, .-dewvm
	.globl	dgemv
	.type	dgemv, @function
dgemv:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -36(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movq	%rcx, -64(%rbp)
	movq	%r8, -72(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L6
.L9:
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -16(%rbp)
	movl	$0, -20(%rbp)
	jmp	.L7
.L8:
	movl	-20(%rbp), %eax
	imull	-36(%rbp), %eax
	movl	%eax, %edx
	movl	-4(%rbp), %eax
	addl	%edx, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-16(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	addl	$1, -20(%rbp)
.L7:
	movl	-20(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl	.L8
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-72(%rbp), %rax
	addq	%rdx, %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-64(%rbp), %rdx
	addq	%rcx, %rdx
	movsd	(%rdx), %xmm0
	addsd	-16(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, -4(%rbp)
.L6:
	movl	-4(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl	.L9
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	dgemv, .-dgemv
	.ident	"GCC: (Debian 6.3.0-18+deb9u1) 6.3.0 20170516"
	.section	.note.GNU-stack,"",@progbits
