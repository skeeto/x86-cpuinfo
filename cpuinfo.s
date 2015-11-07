bits 64
global main
extern printf

section .text
main:	push r12		; (rcx << 32) | rdx
	push r13		; 1-bit mask
	push rbp		; feature string pointer
	push rbx		; clobbered by cpuid
%ifidn __OUTPUT_FORMAT__, win64
	push rdi		; clobbered by scasb
	sub rsp, 32		; shadow space
%else
	sub rsp, 8		; 16-byte alignment
%endif
	mov rbp, featsd
	mov eax, 1
	xor ecx, ecx
	cpuid
	mov r12, rcx
	shl r12, 32
	or  r12, rdx

;; Main feature-printing loop
	mov r13, 1
.loop	test r12, r13
	jz .skip
%ifidn __OUTPUT_FORMAT__, win64
	mov rcx, format
	mov rdx, rbp
	call printf
%else
	mov rdi, format
	mov rsi, rbp
	call printf
%endif
.skip   mov rcx, -1
	mov rdi, rbp
	xor eax, eax
	repne scasb
	mov rbp, rdi
	shl r13, 1
	jnz .loop

;; Cleanup and exit
.ret:
%ifidn __OUTPUT_FORMAT__, win64
	mov rcx, newline
	call printf
	add rsp, 32
	pop rdi
%else
	mov rdi, newline
	call printf
	add rsp, 8
%endif
	pop rbx
	pop rbp
	pop r13
	pop r12
	xor eax, eax
	ret

section .rodata
format:	db `%s \0`
newline:db `\n\0`
featsd:	db `fpu\0vme\0de\0pse\0tsc\0msr\0pae\0mce\0cx8\0apic\0X\0sep\0mtrr\0`
	db `pge\0mca\0cmov\0pat\0pse-36\0psn\0clfsh\0X\0ds\0acpi\0mmx\0fxsr\0`
	db `sse\0sse2\0ss\0htt\0tm\0X\0pbe\0`
featsc:	db `sse3\0pclmulqdq\0dtes64\0monitor\0ds-cpl\0vmx\0smx\0eist\0tm2\0`
	db `ssse3\0cnxt-id\0sdbg\0fma\0cmpxchg16b\0xtpr\0pdcm\0X\0pcid\0dca\0`
	db `sse4.1\0sse4.2\0x2apic\0movbe\0popcnt\0tscd\0aesni\0xsave\0`
	db `osxsave\0avx\0f16c\0rdrand\0X\0`
