; ------------------------------------------------------------------------------
; Count Boxes
; Sets a script variable to the number of Treasure Boxes in the bag!
; ------------------------------------------------------------------------------

.relativeinclude on
.nds
.arm

.definelabel MaxSize, 0x810

; For US
.include "lib/stdlib_us.asm"
.definelabel ProcStartAddress, 0x022E7248
.definelabel ProcJumpAddress, 0x022E7AC0
.definelabel SetGameVar, 0x0204B820
.definelabel GetItemCategoryVeneer, 0x0200CAF0
.definelabel BasePointer, 0x020af6b8

; For EU
;.include "lib/stdlib_eu.asm"
;.definelabel ProcStartAddress, 0x022E7B88
;.definelabel ProcJumpAddress, 0x022E8400
;.definelabel SetGameVar, 0x0204BB58

; File creation
.create "./code_out.bin", 0x022E7248 ; For EU: 0x022E7B88
	.org ProcStartAddress
	.area MaxSize

		push r4-r6 ;r4 = address, r5 = loop_counter, r6 = amount_counter
		ldr r4,=BasePointer
		ldr r4,[r4]
		ldr r4,[r4,#+0x384] ; Current bag
		mov r5,#0
		mov r6,#0
@@bag_loop:
		add r0,r5,#0x4
		ldrh r0,[r4,r0] ; Get item ID
		bl GetItemCategoryVeneer
		cmp r0,#12
		cmpne r0,#13
		cmpne r0,#14
		addeq r6,r6,#1
@@next_bag_iter:
		cmp r5,50*6
		addlt r5,r5,#0x6
		blt @@bag_loop
		mov r0,#0
		mov r1,r7
		mov r2,r6
		bl SetGameVar
		pop r4-r6
		b ProcJumpAddress
		.pool
	.endarea
.close