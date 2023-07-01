; ------------------------------------------------------------------------------
; Check Edible Item
; Returns: If at least one item in the bag is edible!
; ------------------------------------------------------------------------------

.relativeinclude on
.nds
.arm

; EU version is TODO

.definelabel MaxSize, 0x810

; For US
.include "lib/stdlib_us.asm"
.definelabel ProcStartAddress, 0x022E7248
.definelabel ProcJumpAddress, 0x022E7AC0
.definelabel BasePointer, 0x020af6b8

; For EU
;.include "lib/stdlib_eu.asm"
;.definelabel ProcStartAddress, 0x022E7B88
;.definelabel ProcJumpAddress, 0x022E8400
;.definelabel BasePointer, 0x20aff70

; File creation
.create "./code_out.bin", 0x022E7248 ; For EU: 0x022E7B88
	.org ProcStartAddress
	.area MaxSize

		push r4,r5 ;r4 = address, r5 = counter
		ldr r4,=BasePointer
		ldr r4,[r4]
		ldr r4,[r4,#+0x384] ; Current bag
		mov r5,#0
@@bag_loop:
		ldrh r0,[r4,#+0x4] ; Get item ID
		cmp r0,#0
		beq @@ret
		bl #0x0200CB4C ; IsEdible
		cmp r0,#1
		beq @@ret
@@next_bag_iter:
		cmp r5,50*6
		addlt r5,r5,#0x6
		addlt r4,r4,#0x6
		blt @@bag_loop
		mov r0,#0
@@ret:
		pop r4,r5
		b ProcJumpAddress
		.pool
	.endarea
.close