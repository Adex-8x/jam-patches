; ------------------------------------------------------------------------------
; Check Many Team Names
; Checks if a team name is equal to some predefined names!
; Returns: 0 for no match, 1 for Name 1, 2 for Name 2, etc.
; ------------------------------------------------------------------------------


.relativeinclude on
.nds
.arm

.definelabel MaxSize, 0x810

.include "lib/stdlib_us.asm"
.definelabel ProcStartAddress, 0x022E7248
.definelabel ProcJumpAddress, 0x022E7AC0


; File creation
.create "./code_out.bin", 0x022E7248
	.org ProcStartAddress
	.area MaxSize

		push r10
		sub r13,r13,#0x20
		ldr r0,=0x020B0A48
		ldr r0,[r0]
		sub r0,r0,#0x400
		sub r0,r0,#0xc8
		mov r1,r13
		bl AllLowercase
		mov r10,#0
@@name_loop:
		mov r0,r13
		ldr r1,=NAMES
		ldr r1,[r1,r10,lsl #+0x2]
		cmp r1,#0
		moveq r0,#0
		beq @@ret
		mov r2,#10
		bl #0x02089940
		add r10,r10,#1
		cmp r0,#0
		moveq r0,r10
		bne @@name_loop
@@ret:
		add r13,r13,#0x20
		pop r10
		b ProcJumpAddress
		.pool

AllLowercase:
		push r4-r6,r14
		mov r6,r0
		mov r5,r1
		mov r4,#0
		b lowercase_loop_next_iter
lowercase_loop:
		ldrsb r0,[r6],#+0x1
		cmp r0,#0
		beq lowercase_ret
		bl 0x0200238C
		strb r0,[r5],#0x1
		add r4,r4,#0x1
lowercase_loop_next_iter:
		cmp r4,#0xA
		blt lowercase_loop
lowercase_ret:
		mov r0,#0
		strb r0,[r5,#+0x0]
		pop r4-r6,r15

	NAMES:
		.word name_1
		.word name_2
		.word name_3
		.word name_4
		.word 0x0
	; All strings should be in lowercase!
	name_1: 
		.asciiz "sandshrew"
	name_2:
		.asciiz "togetic"
	name_3:
		.asciiz "spiritomb"
	name_4:
		.asciiz "smeargle"
	; As many more names here as you'd like!
	.endarea
.close
