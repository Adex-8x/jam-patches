; ------------------------------------------------------------------------------
; Psychic Puppets - Pressure Mode
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

; For EU
;.include "lib/stdlib_eu.asm"
;.definelabel ProcStartAddress, 0x022E7B88
;.definelabel ProcJumpAddress, 0x022E8400
;.definelabel AssemblyPointer, 0x020B138C

; File creation
.create "./code_out.bin", 0x022E7248 ; For EU: 0x022E7B88
	.org ProcStartAddress
	.area MaxSize

		ldr r0,=AssemblyPointer
		ldr r0,[r0]
		ldr r1,=#0x9898
		add r0,r0,r1
		mov r1,#0
		ldr r3,=#999
@@team_loop:
		ldrh r2,[r0,#+0xa]
		subs r2,r2,r7
		movmi r2,#1
		cmp r2,r3
		movgt r2,r3
		strh r2,[r0,#+0xa]
		cmp r1,#3
		addlt r0,r0,#0x44
		addlt r1,r1,#1
		blt @@team_loop
@@ret:
		b ProcJumpAddress
		.pool
	.endarea
.close