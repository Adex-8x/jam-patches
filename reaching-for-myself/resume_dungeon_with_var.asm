; ------------------------------------------------------------------------------
; Resume Dungeon with Variable
; Must be called between "main_EnterDungeon(dungeon_id, fadeout);"
; and "main_EnterDungeon(-1, fadeout);"!
; Param 1: game_var_id
; Param 2: Nothing
; Returns: Nothing
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
.definelabel DungeonBaseStructPtr, 0x2353538
.definelabel DungeonSetupStruct, 0x022AB4FC
.definelabel GetGameVar, 0x0204B4EC

; For EU
;.include "lib/stdlib_eu.asm"
;.definelabel ProcStartAddress, 0x022E7B88
;.definelabel ProcJumpAddress, 0x022E8400
;.definelabel DungeonBaseStructPtr, 0x2354138
;.definelabel DungeonSetupStruct, 0x022ABE3C
;.definelabel GetGameVar, 0x0204B824


; File creation
.create "./code_out.bin", 0x022E7248 ; For EU: 0x022E7B88
	.org ProcStartAddress
	.area MaxSize
		
		mov r1,r7
		bl GetGameVar
		ldr r1,=DungeonSetupStruct
		strb r0,[r1,#+0x1]
		b ProcJumpAddress
		.pool
	.endarea
.close