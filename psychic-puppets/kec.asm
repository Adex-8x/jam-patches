; ------------------------------------------------------------------------------
; Kecleon IQ Thingy
; Param 1: string_id
; Param 2: game_var_id
; Returns: Nothing
; ------------------------------------------------------------------------------

.relativeinclude on
.nds
.arm

.definelabel MaxSize, 0x810

; For US
.include "lib/stdlib_us.asm"
.definelabel ProcStartAddress, 0x022E7248
.definelabel ProcJumpAddress, 0x022E7AC0
.definelabel GetStringFromScript, 0x022E4248
.definelabel GetGameVarIndexed, 0x0204B678
.definelabel AssemblyPointer, 0x020B0A48

; For EU
;.include "lib/stdlib_eu.asm"
;.definelabel ProcStartAddress, 0x022E7B88
;.definelabel ProcJumpAddress, 0x022E8400
;.definelabel GetStringFromScript, 0x022E4B88
;.definelabel GetGameVar, 0x0204B824

; File creation
.create "./code_out.bin", 0x022E7248 ; For EU: 0x022E7B88
	.org ProcStartAddress
	.area MaxSize

		sub r13,r13,#0x100 ; Allocate as much space as needed for the string!
		mov r1,r6
		mov r2,#0
		bl GetGameVarIndexed
		cmp r0,#150
		moveq r2,#0
		movne r2,#1
		ldr r0,=AssemblyPointer
		ldr r0,[r0]
		add r0,r0,#0x9800
		add r0,r0,#0x4c
		ldr r0,[r0]
		mov r1,#0x68
		mla r0,r2,r1,r0
		ldrh r2,[r0,#+0x6]
		ldr r1,=string
		mov r0,r13
		bl SPrintF
		add r0,r4,#0x14
		mov r1,r7
		bl GetStringFromScript
		mov r1,r13
		bl StrCpy
		add r13,r13,#0x100
		b ProcJumpAddress
		.pool
	string:
		.asciiz " Ah, very well! But please remember[R]that you have [CS:K]%d[CR] IQ remaining, okay?"
	.endarea
.close