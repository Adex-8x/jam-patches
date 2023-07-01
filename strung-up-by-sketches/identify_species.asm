; ------------------------------------------------------------------------------
; Identify Species
; Param 1: id
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

; For EU
;.include "lib/stdlib_eu.asm"
;.definelabel ProcStartAddress, 0x022E7B88
;.definelabel ProcJumpAddress, 0x022E8400
;.definelabel AssemblyPointer, 0x020B138C


; File creation
.create "./code_out.bin", 0x022E7248 ; For EU: 0x022E7B88
	.org ProcStartAddress
	.area MaxSize ; Define the size of the area

		mov r0,r7
		bl SetMonsterAsIdentified
		mov r0,r7
		bl SetPokemonBattled
		b ProcJumpAddress
		.pool
	.endarea
.close