; ------------------------------------------------------------------------------
; Pressure Mode Activate
; Param 1 = Amount to Inc/Dec attacking stats
; Param 2 = Amount to Inc/Dec defensive stats
; ------------------------------------------------------------------------------

.relativeinclude on
.nds
.arm

; Uncomment/comment the following labels depending on your version.

.definelabel MaxSize, 0x810

; For US
.include "lib/stdlib_us.asm"
.definelabel ProcStartAddress, 0x022E7248
.definelabel ProcJumpAddress, 0x022E7AC0
.definelabel AssemblyPointer, 0x020B0A48
.definelabel Copy4BytesArray, 0x0200330C
.definelabel MemZero, 0x2003250

; For EU
;.include "lib/stdlib_eu.asm"
;.definelabel ProcStartAddress, 0x022E7B88
;.definelabel ProcJumpAddress, 0x022E8400
;.definelabel AssemblyPointer, 0x020B138C
;.definelabel Copy4BytesArray, 0x0200330C
;.definelabel MemZero, 0x2003250

; File creation
.create "./code_out.bin", 0x022E7248 ; For EU: 0x022E7B88
	.org ProcStartAddress
	.area MaxSize

		
		push r4,r8
		ldr r8,=AssemblyPointer
		ldr r8,[r8]
		ldr r0,=#0x9870
		ldr r8,[r8,r0]
		mov r4,#0x0
@@team_loop:
		ldrh r3,[r8,r4]
		mov r2,#0x44
		ldr r1,=AssemblyPointer
		ldr r1,[r1]
		mla r1,r3,r2,r1
		ldrb r3,[r1]
		tst r3,#0x1
		beq @@next_loop_iter
		ldrb r3,[r1,#+0xc]
		adds r3,r3,r7
		movmi r3,#1
		cmp r3,#255
		movgt r3,#255
		strb r3,[r1,#+0xc]
		ldrb r3,[r1,#+0xd]
		adds r3,r3,r7
		movmi r3,#1
		cmp r3,#255
		movgt r3,#255
		strb r3,[r1,#+0xd]
		ldrb r3,[r1,#+0xe]
		adds r3,r3,r6
		movmi r3,#1
		cmp r3,#255
		movgt r3,#255
		strb r3,[r1,#+0xe]
		ldrb r3,[r1,#+0xf]
		adds r3,r3,r6
		movmi r3,#1
		cmp r3,#255
		movgt r3,#255
		strb r3,[r1,#+0xf]
@@next_loop_iter:

		cmp r4,#0x6
		addlt r4,r4,#0x2
		blt @@team_loop
		pop r4,r8
		mov r0,#1
@@ret:
		b ProcJumpAddress
		.pool
	.endarea
.close