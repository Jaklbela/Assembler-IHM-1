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
	mov	eax, DWORD PTR -32[rbp]			# массив В
	cdqe
	sal	rax, 2					
	mov	rdi, rax	
	call	malloc@PLT				# окончание создания массива В
	mov	QWORD PTR -16[rbp], rax
	mov	DWORD PTR -4[rbp], 0			# обнуление счетчика
	jmp	.L2					# заходим в цикл
.L5:
	mov	eax, DWORD PTR -4[rbp]			# перенос счетчика
	cdqe
	lea	rdx, 0[0+rax*4]				# смещение указателя
	mov	rax, QWORD PTR -24[rbp]			# перенос элемента массива А
	add	rax, rdx
	mov	eax, DWORD PTR [rax]			# взятие элемента А
	cmp	DWORD PTR -28[rbp], eax			# сравнение среднего значения и элемента А
	jge	.L3					# заходим в иф
	mov	eax, DWORD PTR -4[rbp]			# перенос счетчика
	cdqe
	lea	rdx, 0[0+rax*4]				# смещение указателя
	mov	rax, QWORD PTR -16[rbp]			# перенос элемента массива В
	add	rdx, rax
	mov	eax, DWORD PTR -28[rbp]			# взятие среднего значения
	mov	DWORD PTR [rdx], eax			# перенос среднего значения в элемент В
	jmp	.L4
.L3:
	mov	eax, DWORD PTR -4[rbp]			# перенос счетчика
	cdqe
	lea	rdx, 0[0+rax*4]				# смещение указателя
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	mov	edx, DWORD PTR -4[rbp]			# перенос счетчика
	movsx	rdx, edx
	lea	rcx, 0[0+rdx*4]				# смещение указателя
	mov	rdx, QWORD PTR -16[rbp]
	add	rdx, rcx
	mov	eax, DWORD PTR [rax]			# взятие элемента А
	mov	DWORD PTR [rdx], eax			# перенос элемента А в элемент В
.L4:
	add	DWORD PTR -4[rbp], 1			# увеличение счетчика
.L2:
	mov	eax, DWORD PTR -4[rbp]			# перенос счетчика
	cmp	eax, DWORD PTR -32[rbp]			# сравнение счетчика с размером массива
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
	mov	eax, 0					# зануление будущего количества элементов (n)
	call	__isoc99_scanf@PLT			# вызов функции считывания с консоли
	mov	eax, DWORD PTR -36[rbp]			# считывание количества элементов (n)
	cdqe
	sal	rax, 2					# создание массива А
	mov	rdi, rax
	call	malloc@PLT				# окончание создания массива В
	mov	QWORD PTR -24[rbp], rax
	mov	DWORD PTR -4[rbp], 0			# обнуление среднего значения
	mov	DWORD PTR -8[rbp], 0			# обнуление счетчика
	jmp	.L8					# заходим в цикл
.L9:
	lea	rax, -40[rbp]
	mov	rsi, rax
	lea	rax, .LC0[rip]
	mov	rdi, rax
	mov	eax, 0					# обнуление будущего счетчика
	call	__isoc99_scanf@PLT			# вызов функции чтения с консоли
	mov	eax, DWORD PTR -8[rbp]			# перенос счетчика
	cdqe
	lea	rdx, 0[0+rax*4]				# смещение указателя
	mov	rax, QWORD PTR -24[rbp]
	add	rdx, rax
	mov	eax, DWORD PTR -40[rbp]
	mov	DWORD PTR [rdx], eax
	mov	eax, DWORD PTR -40[rbp]			# положили среднее значение в регистр
	add	DWORD PTR -4[rbp], eax			# сложили среднее значение с новым элементов
	add	DWORD PTR -8[rbp], 1			# смещение счетчика
.L8:
	mov	eax, DWORD PTR -36[rbp]
	cmp	DWORD PTR -8[rbp], eax			# сравнение счетчика с размером массива
	jl	.L9
	mov	ecx, DWORD PTR -36[rbp]
	mov	eax, DWORD PTR -4[rbp]			# кладем среднее значение в регистр
	cdq
	idiv	ecx					# делим среднее значение
	mov	DWORD PTR -4[rbp], eax
	mov	edx, DWORD PTR -36[rbp]			# передача массива А в функцию
	mov	ecx, DWORD PTR -4[rbp]			# передача среднего значения в функцию
	mov	rax, QWORD PTR -24[rbp]			# передача размера массива в функцию
	mov	esi, ecx
	mov	rdi, rax
	call	create_array
	mov	QWORD PTR -32[rbp], rax			# присвоение массиву В возвращаемого значения функции
	mov	DWORD PTR -12[rbp], 0			# обнуляем счетчик
	jmp	.L10
.L11:
	mov	eax, DWORD PTR -12[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]				# смещение указателя
	mov	rax, QWORD PTR -32[rbp]
	add	rax, rdx
	mov	eax, DWORD PTR [rax]			# берем элемент массива В
	mov	esi, eax
	lea	rax, .LC1[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT				# печатаем элемент В
	add	DWORD PTR -12[rbp], 1			# увеличиваем счетчик
.L10:
	mov	eax, DWORD PTR -36[rbp]
	cmp	DWORD PTR -12[rbp], eax			# сравниваем счетчик
	jl	.L11					# заходим в цикл
	mov	eax, 0
	leave
	ret
