; ------------------------------------------------------------------------------
; Barb Barrage
; I forgot what this does oops
; ------------------------------------------------------------------------------

.relativeinclude on
.nds
.arm

.definelabel MaxSize, 0x2598

; Uncomment/comment the following labels depending on your version.

; For US
.include "lib/stdlib_us.asm"
.include "lib/dunlib_us.asm"
.definelabel MoveStartAddress, 0x02330134
.definelabel MoveJumpAddress, 0x023326CC

; For EU
;.include "lib/stdlib_eu.asm"
;.include "lib/dunlib_eu.asm"
;.definelabel MoveStartAddress, 0x02330B74
;.definelabel MoveJumpAddress, 0x0233310C

; File creation
.create "./code_out.bin", 0x02330134 ; For EU: 0x02330B74
	.org MoveStartAddress
	.area MaxSize

		sub r13,r13,#0x4
		ldr r0,[r4,#+0xb4]
		ldrb r1,[r0,#+0xbd]
		ldrb r2,[r0,#+0xbf]
		cmp r1,#2
		cmpne r1,#3
		moveq r3,#0x180
		movne r3,#0x180
@@damage:
		mov r0,r9
		mov r1,r4
		mov r2,r8
		str r7,[r13]
		bl DealDamage
		mov r10,r0
		add r13,r13,#0x4
		b MoveJumpAddress
		.pool
	.endarea
.close