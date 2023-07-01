; ------------------------------------------------------------------------------
; Reset Smeargle Moveset
; No params
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
.definelabel AssemblyPointer, 0x020B0A48
.definelabel SetPokemonBattled, 0x0204FE58
.definelabel SetMonsterAsIdentified, 0x0204D1C4
.definelabel MemZero, 0x02003250
.definelabel InitMove, 0x020137B8
.definelabel DungeonToGroundMove, 0x020146AC

; For EU
;.include "lib/stdlib_eu.asm"
;.definelabel ProcStartAddress, 0x022E7B88
;.definelabel ProcJumpAddress, 0x022E8400
;.definelabel AssemblyPointer, 0x020B138C


; File creation
.create "./code_out.bin", 0x022E7248 ; For EU: 0x022E7B88
	.org ProcStartAddress
	.area MaxSize ; Define the size of the area

		push r4
		sub r13,r13,#0x8
		mov r0,r13
		mov r1,#254
		bl InitMove
		ldr r0,=AssemblyPointer
		ldr r4,[r0]
		add r0,r4,#0x22
		mov r1,r13
		bl DungeonToGroundMove
		add r0,r4,#0x28
		mov r1,#18
		bl MemZero
		mov r0,#0
		add r13,r13,#0x8
		pop r4
		b ProcJumpAddress
		.pool
	.endarea
.close