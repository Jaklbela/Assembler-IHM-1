# Отчет по ИДЗ №1

## 4 балла

### Код на C
```c
#include <stdio.h>

static int A[2048];
static int B[2048];

int main(int argc, char** argv) {
    int n, i;

    scanf("%d", &n);
    int middle = 0;
    for (i = 0; i < n; ++i) {
        int el;
        scanf("%d", &el);
        A[i] = el;
        middle += el;
    }

    middle /= n;
    for (i = 0; i < n; ++i) {
        if (A[i] > middle) {
            B[i] = middle;
        } else {
            B[i] = A[i];
        }
    }

    for (i = 0; i < n; ++i) {
        printf("%d ", B[i]);
    }

    return 0;
}
```

### Компиляция программы без оптимизаций
```sh
gcc -masm=intel mainprog.c -S -o mainprog.s
```

### Неоптимизированный код на ассемблере с комментариями
``` assembly

.file	"mainprog.c"			# название исходного файла
	.intel_syntax noprefix			# указание на синтаксис intel
	
	.text				# начало новой секции
	.local	A				# объявляем первый массив
	.comm	A,8192,32			# инициализируем первый массив
	.local	B				# объявляем второй массив
	.comm	B,8192,32			# инициализируем второй массив
	
	.section	.rodata			# переходим в секцию .rodata
.LC0:					# метка .LC0
	.string	"%d"				# кладем в строку "%d0\"
.LC1:					# метка .LC1
	.string	"%d "				# кладем в строку "%d0\"
	
	.text				# новая секция
	.globl	main				# объявляем и экспортируем символ main
	.type	main, @function			# показываем, что main функция
main:					# метка main
.LFB0:					# метка .LFB0:
	.cfi_startproc				# -
	endbr64					# -
	push	rbp				# сохранили предыдущий rbp на стек
	.cfi_def_cfa_offset 16			# -
	.cfi_offset 6, -16			# -
	mov	rbp, rsp			# вместо rbp записали rsp
	.cfi_def_cfa_register 6			# -
	sub	rsp, 48				# сдвинули rsp на 48 байт
	mov	DWORD PTR -36[rbp], edi		# rbp[-36] = edi - первый аргумент, 
							# `argc` (rdi)
	mov	QWORD PTR -48[rbp], rsi		# rbp[-48] = rsi - второй аргумент,
							# `argv` (rsi)
	mov	rax, QWORD PTR fs:40		# / stack protection, можно игнорировать
	mov	QWORD PTR -8[rbp], rax		# \
	xor	eax, eax			# обнуляем eax
	lea	rax, -24[rbp]			# rax = rbp[-24] — переменная n на стеке
	mov	rsi, rax			# переносим rax в rsi
	lea	rax, .LC0[rip]			# rax = rip[.LC0] — строка "%d"
	mov	rdi, rax			# переносим rax в rdi
	mov	eax, 0				# снова обнуляем eax, но другим способом
	call	__isoc99_scanf@PLT		# вызов функции scanf. В этот момент rax = 0, rdi = rip[.LC0], rsi = rbp[-24]
	mov	DWORD PTR -12[rbp], 0		# rbp[-12] = 0 - счетчик цикла
	mov	DWORD PTR -16[rbp], 0		# rbp[-16] = 0 - счетчик цикла
	jmp	.L2				# переход к метке .L2 - проверка условия цикла
.L3:					# метка .L3
	lea	rax, -20[rbp]			# rax = rbp[-20] - элемент массива на стеке
	mov	rsi, rax			# переносим rax в rsi
	lea	rax, .LC0[rip]			# rax = rip[.LC0] — строка "%d"
	mov	rdi, rax			# переносим rax в rdi
	mov	eax, 0				# обнуляем eax (счетчик)
	call	__isoc99_scanf@PLT		# вызов функции scanf. В этот момент rax = 0, rdi = rip[.LC0], rsi = rbp[-20]
	mov	eax, DWORD PTR -20[rbp]		# eax = rbp[-20]
	mov	edx, DWORD PTR -16[rbp]		# edx = rbp[-16]
	movsx	rdx, edx			# переносим edx в rdx (перенос знаковых чисел)
	lea	rcx, 0[0+rdx*4]			# rcx = rcx * 4 —  вычисляет адрес (rcx*4)[0], который равен rcx*4
	lea	rdx, A[rip]			# rdx = &rip[A] — адрес начала массива A
	mov	DWORD PTR [rcx+rdx], eax	# в rcx[rdx] записываем eax - кладем элемент в массив
	mov	eax, DWORD PTR -20[rbp]		# eax = rbp[-20]
	add	DWORD PTR -12[rbp], eax		# rbp[-12] += eax (увеличиваем сумму для ср. арифм.)
	add	DWORD PTR -16[rbp], 1		# rbp[-16] += 1 (увеличиваем счетчик)
.L2:					# метка .L2
	mov	eax, DWORD PTR -24[rbp]		# eax = rbp[-24]
	cmp	DWORD PTR -16[rbp], eax		# сравниваем rbp[-16] и eax (счетчик цикла и n)
	jl	.L3				# если меньше, то переход к метке .L3, иначе выход из цикла
	mov	esi, DWORD PTR -24[rbp]		# переносим rbp[-24] в esi
	mov	eax, DWORD PTR -12[rbp]		# переносим rbp[-12] в eax
	cdq					# расширение двойного слова до учетверенного со знаком
	idiv	esi				# деление esi со знаком
	mov	DWORD PTR -12[rbp], eax		# переносим eax в rbp[-12]
	mov	DWORD PTR -16[rbp], 0		# обнуляем rbp[-16] - счетчик
	jmp	.L4				# переход к метке .L2 - проверка условия второго цикла
.L7:					# метка .L7
	mov	eax, DWORD PTR -16[rbp]		# eax = rbp[-16]
	cdqe					# sign-extended, используем знак
	lea	rdx, 0[0+rax*4]			# rdx = rax * 4 —  вычисляет адрес (rax*4)[0], который равен rax*4
	lea	rax, A[rip]			# rax = &rip[A] — адрес начала массива A
	mov	eax, DWORD PTR [rdx+rax]	# записываем rdx[rax] в eax - кладем элемент в массив A
	cmp	DWORD PTR -12[rbp], eax		# сравниваем rbp[-12] и eax - счетчик цикла
	jge	.L5				# выполняет переход к метке .L5 при значении больше - проверка условия if
	mov	eax, DWORD PTR -16[rbp]		# eax = rbp[-16]
	cdqe					# sign-extended, используем знак
	lea	rcx, 0[0+rax*4]			# rcx = rax * 4 —  вычисляет адрес (rax*4)[0], который равен rax*4
	lea	rdx, B[rip]			# rdx = &rip[B] — адрес начала массива B
	mov	eax, DWORD PTR -12[rbp]		# eax = rbp[-12]
	mov	DWORD PTR [rcx+rdx], eax	# rcx[rdx] = eax - кладем элемент в массив B
	jmp	.L6				# переход к метке .L6 - увеличение счетчика
.L5:					# метка .L5
	mov	eax, DWORD PTR -16[rbp]		# eax = rbp[-16]
	cdqe					# sign-extended, используем знак
	lea	rdx, 0[0+rax*4]			# rdx = rax * 4 —  вычисляет адрес (rax*4)[0], который равен rax*4
	lea	rax, A[rip]			# rax = &rip[A] — адрес начала массива A
	mov	eax, DWORD PTR [rdx+rax]	# записываем rdx[rax] в eax - кладем элемент в массив A
	mov	edx, DWORD PTR -16[rbp]		# edx = rbp[-16]
	movsx	rdx, edx			# переносим edx в rdx (перенос знаковых чисел)
	lea	rcx, 0[0+rdx*4]			# rcx = rdx * 4 —  вычисляет адрес (rdx*4)[0], который равен rdx*4
	lea	rdx, B[rip]			# rdx = &rip[B] — адрес начала массива B
	mov	DWORD PTR [rcx+rdx], eax	# записываем eax в rcx[rdx] - кладем элемент в массив B
.L6:					# метка .L6
	add	DWORD PTR -16[rbp], 1		# rbp[-16] += 1 - увеличиваем счетчик
.L4:					# метка .L4
	mov	eax, DWORD PTR -24[rbp]		# eax = rbp[-24]
	cmp	DWORD PTR -16[rbp], eax		# сравниваем rbp[-16] и eax - счетчик цикла
	jl	.L7				# если меньше, то переход к метке .L7, иначе выход из цикла
	mov	DWORD PTR -16[rbp], 0		# rbp[-16] = 0 - счетчик равен 0
	jmp	.L8				# переход к метке .L8 - условие else
.L9:					# метка .L9
	mov	eax, DWORD PTR -16[rbp]		# eax = rbp[-16]
	cdqe					# sign-extended, используем знак
	lea	rdx, 0[0+rax*4]			# rdx = rax * 4 —  вычисляет адрес (rax*4)[0], который равен rax*4
	lea	rax, B[rip]			# rax = &rip[B] — адрес начала массива B
	mov	eax, DWORD PTR [rdx+rax]	# записываем eax в rcx[rdx] - кладем элемент в массив B
	mov	esi, eax			# esi = eax
	lea	rax, .LC1[rip]			# rax = rip[.LC1]
	mov	rdi, rax			# rdi = rax
	mov	eax, 0				# eax = 0
	call	printf@PLT			# вызываем функцию printf@PLT - печать в консоль
	add	DWORD PTR -16[rbp], 1		# rbp[-16] += 1 - увеличиваем счетчик
.L8:					# метка .L8
	mov	eax, DWORD PTR -24[rbp]		# eax = rbp[-24]
	cmp	DWORD PTR -16[rbp], eax		# сравниваем rbp[-16] и eax (счетчик цикла и n)
	jl	.L9				# если меньше, то переход к метке .L9, иначе выход из цикла
	mov	eax, 0				# eax = 0
	mov	rdx, QWORD PTR -8[rbp]		# rdx = rbp[-8]
	sub	rdx, QWORD PTR fs:40		# -
	je	.L11				# условный переход - при единице переход к метке .L11
	call	__stack_chk_fail@PLT		# вызов функции __stack_chk_fail@PLT - можно игнорировать
.L11:					# метка .L8
	leave					# эпилог. Дальше можно игнорировать
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
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
```

### Компиляция программы с оптимизацией
```sh
gcc -masm=intel \
    -fno-asynchronous-unwind-tables \
    -fno-jump-tables \
    -fno-stack-protector \
    -fno-exceptions \
    ./mainprog.c \
    -S -o ./optimized.s
```

### Оптимизированный код ассемблера (без комментариев)
``` assembly
.intel_syntax noprefix
	.text
	.local	A
	.comm	A,8192,32
	.local	B
	.comm	B,8192,32
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
	sub	rsp, 32
	mov	DWORD PTR -20[rbp], edi
	mov	QWORD PTR -32[rbp], rsi
	lea	rax, -12[rbp]
	mov	rsi, rax
	lea	rax, .LC0[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT
	mov	DWORD PTR -8[rbp], 0
	mov	DWORD PTR -4[rbp], 0
	jmp	.L2
.L3:
	lea	rax, -16[rbp]
	mov	rsi, rax
	lea	rax, .LC0[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_scanf@PLT
	mov	eax, DWORD PTR -16[rbp]
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	lea	rcx, 0[0+rdx*4]
	lea	rdx, A[rip]
	mov	DWORD PTR [rcx+rdx], eax
	mov	eax, DWORD PTR -16[rbp]
	add	DWORD PTR -8[rbp], eax
	add	DWORD PTR -4[rbp], 1
.L2:
	mov	eax, DWORD PTR -12[rbp]
	cmp	DWORD PTR -4[rbp], eax
	jl	.L3
	mov	esi, DWORD PTR -12[rbp]
	mov	eax, DWORD PTR -8[rbp]
	cdq
	idiv	esi
	mov	DWORD PTR -8[rbp], eax
	mov	DWORD PTR -4[rbp], 0
	jmp	.L4
.L7:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, A[rip]
	mov	eax, DWORD PTR [rdx+rax]
	cmp	DWORD PTR -8[rbp], eax
	jge	.L5
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rcx, 0[0+rax*4]
	lea	rdx, B[rip]
	mov	eax, DWORD PTR -8[rbp]
	mov	DWORD PTR [rcx+rdx], eax
	jmp	.L6
.L5:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, A[rip]
	mov	eax, DWORD PTR [rdx+rax]
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	lea	rcx, 0[0+rdx*4]
	lea	rdx, B[rip]
	mov	DWORD PTR [rcx+rdx], eax
.L6:
	add	DWORD PTR -4[rbp], 1
.L4:
	mov	eax, DWORD PTR -12[rbp]
	cmp	DWORD PTR -4[rbp], eax
	jl	.L7
	mov	DWORD PTR -4[rbp], 0
	jmp	.L8
.L9:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 0[0+rax*4]
	lea	rax, B[rip]
	mov	eax, DWORD PTR [rdx+rax]
	mov	esi, eax
	lea	rax, .LC1[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT
	add	DWORD PTR -4[rbp], 1
.L8:
	mov	eax, DWORD PTR -12[rbp]
	cmp	DWORD PTR -4[rbp], eax
	jl	.L9
	mov	eax, 0
	leave
	ret
```

### Тестовые прогоны

Используемые входные данные (массивы): 1. (4 5 8 0), 2. (13 1768 56 97 36 27 85 56 876), 3. (-1 17 0 -567 65 -43 15)
Выходные данные (у кода mainprog.c и mainprog.s): 1. (4 4 4 0), 2. (13 334 56 97 36 27 85 56 334), 4. (-73 -73 -73 -567 -73 -73 -73)
Подтверждающие тесты скриншоты находятся в репозитории:

