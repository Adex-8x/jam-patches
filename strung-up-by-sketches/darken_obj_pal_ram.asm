; ------------------------------------------------------------------------------
; Darken Object Palette RAM
; Param 1: engine
; ------------------------------------------------------------------------------

.relativeinclude on
.nds
.arm

; Uncomment/comment the following labels depending on your version.

.definelabel MaxSize, 0x810

.include "lib/stdlib_us.asm"
.definelabel ProcStartAddress, 0x022E7248
.definelabel ProcJumpAddress, 0x022E7AC0

; File creation
.create "./code_out.bin", 0x022E7248
	.org ProcStartAddress
	.area MaxSize

		cmp r7,#0
		ldreq r0,=0x05000200
		ldrne r0,=0x05000600
		mov r1,#0x200
		bl 0x02003288
		b ProcJumpAddress
		.pool
	.endarea
.close