; ------------------------------------------------------------------------------
; Psychic Puppets - Convert Items to Move Boosts
; Evenly distributes the number of items in the bag to Move Boosts to the player and partner!
; If you are using this on current party members, call Irdkwia's "Remove Party" process before this one!
; Param 1: Include Partner
; Param 2: Bag/Storage (0 is Bag, else is Storage)
; Returns: 1 if successful, 0 if the player has less than four items in the bag.
; ------------------------------------------------------------------------------

.relativeinclude on
.nds
.arm

.definelabel MaxSize, 0x810

; For US
.include "lib/stdlib_us.asm"
.definelabel ProcStartAddress, 0x022E7248
.definelabel ProcJumpAddress, 0x022E7AC0
.definelabel BasePointer, 0x020af6b8
.definelabel AssemblyPointer, 0x20B0A48
.definelabel RemoveAllItemsStartingAt, 0x0200F7DC
.definelabel RemoveStuff, 0x0200326C

; For EU
;.include "lib/stdlib_eu.asm"
;.definelabel ProcStartAddress, 0x022E7B88
;.definelabel ProcJumpAddress, 0x022E8400
;.definelabel BasePointer, 0x20aff70
;.definelabel AssemblyPointer, 0x20B138C
;.definelabel RemoveAllItemsStartingAt, 0x0200F884
;.definelabel RemoveStuff, 0x0200326C

; File creation
.create "./code_out.bin", 0x022E7248 ; For EU: 0x022E7B88
	.org ProcStartAddress
	.area MaxSize

		; r1 = address, r2 = counter, r0 = total. r12 and r3 are scratch
		cmp r6,#0
		bne @@storage_start
		ldr r1,=BasePointer
		ldr r1,[r1]
		ldr r1,[r1,#+0x384] ; Current bag
		mov r2,#0
		mov r0,#0
@@bag_loop:
		ldrh r12,[r1,#+0x4] ; Get item ID
		cmp r12,#0
		ble @@next_bag_iter
		ldrh r12,[r1,#+0x2] ; Get stack count
		cmp r12,#0
		addle r0,r0,#1
		addgt r0,r0,r12
@@next_bag_iter:
		cmp r2,50*6
		addlt r2,r2,#0x6
		addlt r1,r1,#0x6
		blt @@bag_loop
		b @@finish_item_iter
@@storage_start:
		ldr r1,=BasePointer
		ldr r1,[r1]
		add r1,r1,#0x8A
		add r1,r1,#0x300
		mov r2,#0
		mov r0,#0
@@storage_loop:
		ldrh r12,[r1,r2]
		cmp r12,#0
		ble @@next_storage_iter
		add r3,r2,#0x7d0
		ldrh r12,[r1,r3] ; Get stack count
		cmp r12,#0
		addle r0,r0,#1
		addgt r0,r0,r12
@@next_storage_iter:
		cmp r2,2*1000
		addlt r2,r2,#0x2
		blt @@storage_loop
@@finish_item_iter:
		cmp r0,#4
		movlt r0,#0
		blt @@ret
		; Apply stuff onto move boosts
		lsr r0,r0,#2
		ldr r1,=AssemblyPointer
		ldr r1,[r1]
		mov r2,#0x26
		; r1 = address, r2 = counter, r0 = total, r3 = scratch
@@move_loop_hero:
		ldrb r3,[r1,r2]
		add r3,r3,r0
		cmp r3,#99
		movgt r3,#99
		strb r3,[r1,r2]
		cmp r2,#0x38
		addlt r2,r2,#0x6
		blt @@move_loop_hero
		
		cmp r7,#0
		beq @@remove_items
		mov r2,#0x26
		add r1,r1,#0x44
@@move_loop_partner:
		ldrb r3,[r1,r2]
		add r3,r3,r0
		cmp r3,#99
		movgt r3,#99
		strb r3,[r1,r2]
		cmp r2,#0x38
		addlt r2,r2,#0x6
		blt @@move_loop_partner

@@remove_items:
		push r4
		mov r4,r0
		mov r0,#0
		cmp r6,#0
		bleq RemoveAllItemsStartingAt
		ldrne r0,=BasePointer
		ldrne r0,[r0]
		addne r0,r0,#0x8A
		addne r0,r0,#0x300
		movne r1,#0x7D0
		blne RemoveStuff
		mov r0,r4
		pop r4
@@ret:
		b ProcJumpAddress
		.pool
	.endarea
.close