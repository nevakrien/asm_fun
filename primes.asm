;windows calling convention!!!!
;default rel ;linux attempt

extern malloc


section .text
global x86_sqrt
global x86_prime_factors
;extern malloc ;linux attempt

;if u refactor this make sure to check x86_prime_factors that u didnt take too many registers
x86_sqrt:
    ; Assume input x is in rcx
    test rcx, rcx         ; Check if input is zero
    jz   ret_0 ; Handle the case where input is zero to avoid undefined behavior
    mov rsi,rcx

    ; Calculate the maximum possible shift (log2(x))/2
    bsr rcx, rcx            ; Index of highest set bit in rcx
    shr rcx, 1              ;(log2(x))/2

    ; Set starting point to 2^rcx
    mov r8, 1  ;1
    shl r8, cl ;2^cl (since log2(x)<256 cx fits in cl)

    ; Set starting point
    xor rcx, rcx
    jmp binary_search_start
    
    align 16
    binary_search_undo:
        sub rcx, r8 ;undo the last rcx+=r8
    binary_search_inc:	
    	shr r8, 1 ;r8=r8/2
    	cmp r8,0 ;if r8=0 the loop wont change we are done
        jz end_binary_search
    binary_search_start:
        add rcx, r8 ;rax+=r8

        mov rax, rcx
        mul rax ;rax=rcx^2
        cmp rsi, rax        ; Compare the original x with the square of the current guess
        ja binary_search_inc ;wont triger
        jb binary_search_undo ;wont triger
    	
    end_binary_search:
        mov rax,rcx
        ret
    
    ret_0:
        xor rax, rax        ; If input is zero, return zero
        ret

;calling convention hell
x86_prime_factors:
	push rsp
	push r12 ;counter
	push rdi
	push r13 ;for saving the return adress????
	
	mov r13,rcx

	;seems that edx may hold the arguments need to double check here
	mov rdi,rsp ;keep base so we can work.

	;mov r10,rcx ;r10 holds the number
	mov r10,rdx ;r10 holds the number

	xor r12,r12 ;number of factors

	;check 2
	;bsr rcx, rcx
	bsr rcx, rdx
	
	jz check_3
	shr r10,cl

	inc r12b
	;write [2 u64, rcx u8]
	sub rsp, 9           
	mov qword [rsp+1], 2
	mov  [rsp], cl ;needs to be 1 byte only
	

	;same logic for 3 now we need div
	mov r8,3
	cmp r10,r8
	jng return

	check_3:
	;divide by 3
	mov rax,r10
	xor rdx,rdx
	div r8;	
	test rdx,rdx
	jz setup_6_loop

	
	;done in loop anyway ;mov r10,rax
	inc r12b

	sub rsp, 9           
	mov qword [rsp+1], 3
	xor rcx,rcx ;rcx holds the current div count

	align 16
	loop_3:
		mov r10,rax
		add rcx,1
		xor rdx,rdx
		div r8;	
		test rdx,rdx
		jz loop_3

	mov  [rsp], cl

	setup_6_loop:
	mov rcx,r10
	call x86_sqrt
	mov r9,rax ;now we have a cap

	xor r8,r8
	;jmp main_loop

	align 16
	main_loop:
	add r8,5 ;r8 holds our dividsor

	cmp r9,r8
	jng return
	cmp r10,r8
	jae check_6k_m
	
	return:
		sub rdi,rsp
		call malloc
		;our return pointer is in rax like we need it to
		test rax,rax
		jz err_return
		
		;memcpy the stack into the malloced memory
		;we will and at ;add rdi,rsp ;our base pointer
		
		mov rsi, rsp 
		mov rdi, rax

		mov rcx, r12
		rep movsb
		mov rcx, r12
		rep movsq

		mov rsp,rsi
		jmp general_return

	err_return:
		;reset stack 8+8+8=24
		add rdi,rsp ;undo our subtruction
		lea rsp,[rdi-24]
		xor r12,r12

	general_return:
		;mov rdx,r12
		;apperently this is how we return things?
	    mov [r13], rax        
	    ;mov rax, r13          ; gcc did this on O3 idx why
	    ;mov rcx, r13			; also an assumbtion that can be made
	    mov BYTE [8+r13], r12b  


		pop r13
		pop rdi
		pop r12
		pop rsp
 
		ret

	check_6k_m:
		;divide by r8
		mov rax,r10
		xor rdx,rdx
		div r8;	
		test rdx,rdx
		jz check_6k_p

		
		;done in loop anyway ;mov r10,rax
		inc r12b

		sub rsp, 9           
		mov qword [rsp+1], 3
		xor rcx,rcx ;rcx holds the current div count

		align 16
		loop_6k_m:
			mov r10,rax
			add rcx,1
			xor rdx,rdx
			div r8;	
			test rdx,rdx
			jz loop_6k_m

		mov  [rsp], cl


	check_6k_p:
		add r8,2 ;moving to the + case
		;divide by r8
		mov rax,r10
		xor rdx,rdx
		div r8;	
		test rdx,rdx
		jz main_loop

		
		;done in loop anyway ;mov r10,rax
		inc r12b

		sub rsp, 9           
		mov qword [rsp+1], 3
		xor rcx,rcx ;rcx holds the current div count

		align 16
		loop_6k_p:
			mov r10,rax
			add rcx,1
			xor rdx,rdx
			div r8;	
			test rdx,rdx
			jz loop_6k_p

		mov  [rsp], cl
		jmp main_loop



