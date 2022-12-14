	.intel_syntax noprefix
	.text
	.globl	create_array
	.type	create_array, @function
create_array:
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	mov	QWORD PTR -24[rbp], rdi			# передача массива А
	mov	DWORD PTR -28[rbp], esi			# передача среднего значения
	mov	DWORD PTR -32[rbp], edx			# передача размера массива
	mov	eax, DWORD PTR -32[rbp]
	cdqe
	sal	rax, 2	
	mov	rdi, rax	
	call	malloc@PLT
	mov	QWORD PTR -16[rbp], rax
	mov	DWORD PTR -4[rbp], 0
	jmp	.L2
.L5:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -28[rbp], eax
	jge	.L3
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	mov	rax, QWORD PTR -16[rbp]
	add	rdx, rax
	mov	eax, DWORD PTR -28[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L4
.L3:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	lea	rcx, 0[0+rdx*4]
	mov	rdx, QWORD PTR -16[rbp]
	add	rdx, rcx
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rdx], eax
.L4:
	add	DWORD PTR -4[rbp], 1
.L2:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -32[rbp]
	jl	.L5
	mov	rax, QWORD PTR -16[rbp]			# передача массива В из функции в основную программу
	leave
	ret
	.size	create_array, .-create_array
	.section	.rodata
.LC0:
	.string	"%d"
.LC1:
	.string	"%d "
	.text
	.globl	main
	.type	main, @function
main:
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 64
	mov	DWORD PTR -52[rbp], edi
	mov	QWORD PTR -64[rbp], rsi
	lea	rax, -36[rbp]
	mov	rsi, rax
	lea	rax, .LC0[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT
	mov	eax, DWORD PTR -36[rbp]
	cdqe
	sal	rax, 2
	mov	rdi, rax
	call	malloc@PLT
	mov	QWORD PTR -24[rbp], rax
	mov	DWORD PTR -4[rbp], 0
	mov	DWORD PTR -8[rbp], 0
	jmp	.L8
.L9:
	lea	rax, -40[rbp]
	mov	rsi, rax
	lea	rax, .LC0[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT
	mov	eax, DWORD PTR -8[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	mov	rax, QWORD PTR -24[rbp]
	add	rdx, rax
	mov	eax, DWORD PTR -40[rbp]
	mov	DWORD PTR [rdx], eax
	mov	eax, DWORD PTR -40[rbp]
	add	DWORD PTR -4[rbp], eax
	add	DWORD PTR -8[rbp], 1
.L8:
	mov	eax, DWORD PTR -36[rbp]
	cmp	DWORD PTR -8[rbp], eax
	jl	.L9
	mov	ecx, DWORD PTR -36[rbp]
	mov	eax, DWORD PTR -4[rbp]
	cdq
	idiv	ecx
	mov	DWORD PTR -4[rbp], eax
	mov	edx, DWORD PTR -36[rbp]			# передача массива А в функцию
	mov	ecx, DWORD PTR -4[rbp]			# передача среднего значения в функцию
	mov	rax, QWORD PTR -24[rbp]			# передача размера массива в функцию
	mov	esi, ecx
	mov	rdi, rax
	call	create_array
	mov	QWORD PTR -32[rbp], rax			# присвоение массиву В возвращаемого значения функции
	mov	DWORD PTR -12[rbp], 0
	jmp	.L10
.L11:
	mov	eax, DWORD PTR -12[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	mov	rax, QWORD PTR -32[rbp]
	add	rax, rdx
	mov	eax, DWORD PTR [rax]
	mov	esi, eax
	lea	rax, .LC1[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT
	add	DWORD PTR -12[rbp], 1
.L10:
	mov	eax, DWORD PTR -36[rbp]
	cmp	DWORD PTR -12[rbp], eax
	jl	.L11
	mov	eax, 0
	leave
	ret
