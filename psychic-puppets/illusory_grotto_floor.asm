; ------------------------------------------------------------------------------
; Set Floor Count
; Param 1: dungeon_id
; Param 2: floor_count (100 = Special: Random from 1-13)
; Quicksaves probably break this but lmao who cares
; ------------------------------------------------------------------------------

.relativeinclude on
.nds
.arm

.definelabel MaxSize, 0x810

; Uncomment/comment the following labels depending on your version.

; For US
.include "lib/stdlib_us.asm"
.definelabel ProcStartAddress, 0x022E7248
.definelabel ProcJumpAddress, 0x022E7AC0
.definelabel DungeonDataList, 0x209E3A0
.definelabel RNG, 0x2002318
.definelabel GetPartyMembers, 0x2056C20

; For EU
;.include "lib/stdlib_eu.asm"
;.definelabel ProcStartAddress, 0x022E7B88
;.definelabel ProcJumpAddress, 0x022E8400
;.definelabel AssemblyPointer, 0x20B138C


; File creation
.create "./code_out.bin", 0x022E7248 ; For EU: 0x022E7B88
	.org ProcStartAddress
	.area MaxSize ; Define the size of the area

		ldr r0,=DungeonDataList
		mov r1,#4
		mla r0,r1,r7,r0
		cmp r6,#100
		bge @@illusory_grotto
		strb r6,[r0]
		b @@ret
@@illusory_grotto:
		push r0
		mov r0,#0
		bl GetPartyMembers
		lsl r0,r0,#1
		mov r1,#14
		bl RNG
		mov r1,r0
		pop r0
		strb r1,[r0]
@@ret:
		b ProcJumpAddress
		.pool
	.endarea
.close