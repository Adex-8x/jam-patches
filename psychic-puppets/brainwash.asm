; ------------------------------------------------------------------------------
; Brainwash
; The target joins the user's side!
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
.definelabel GetGameVarIndexed, 0x0204B678
.definelabel DungeonBaseStructPtr, 0x2353538
.definelabel HasLowHealth, 0x22FB610
.definelabel SetGameVarIndexed, 0x0204B988 

; For EU
;.include "lib/stdlib_eu.asm"
;.include "lib/dunlib_eu.asm"
;.definelabel MoveStartAddress, 0x02330B74
;.definelabel MoveJumpAddress, 0x0233310C

; File creation
.create "./code_out.bin", 0x02330134 ; For EU: 0x02330B74
	.org MoveStartAddress
	.area MaxSize

		mov r1,#18
		ldr r2,=#42
		bl GetGameVarIndexed
		cmp r0,#1
		beq @@leader
		ldr r0,[r9,#+0xb4]
		ldrsh r1,[r0,#+0x12]
		ldrsh r2,[r0,#+0x16]
		add r1,r1,r2
		lsr r1,r1,#2
		ldrsh r0,[r0,#+0x10]
		cmp r0,r1
		ble @@low_hp
		ldr r0,[r4,#+0xb4]
		ldrb r1,[r0,#0x9]
		cmp r1,#1
		bgt @@too_late
		ldr r0,[r9,#+0xb4]
		ldrb r1,[r0,#0x6]
		cmp r1,#0
		beq @@ally_user
		ldrb r1,[r0,#0x8]
		cmp r1,#0
		bne @@ally_user
		ldr r0,[r4,#+0xb4]
		ldrb r1,[r0,#+0x7]
		cmp r1,#0
		bne @@leader
		push r0
		ldr r0,[r9,#+0xb4]
		ldrsh r1,[r0,#+0x12]
		ldrsh r0,[r0,#+0x16]
		add r0,r0,r1
		lsr r0,r0,#2
		mov r1,r0
		mov r0,r9
		mov r2,#0
		mov r3,#0
		str r2,[r13,#+0x0c]
		bl ConstDamage
		mov r0,#0
		mov r1,r9
		mov r2,#0
		bl ChangeString
		mov r0,#1
		mov r1,r4
		mov r2,#0
		bl ChangeString
		mov r0,r9
		ldr r1,=success
		bl SendMessageWithStringLog
		pop r0
		mov r1,#3
		strb r1,[r0,#+0x9]
		mov r1,#0xd9 ; Bidoof's Location (to disable tactics)
		strb r1,[r0,#+0x48]
		mov r1,#0
		strb r1,[r0,#+0xa8] ; Let's go together
		add r0,r0,#0x124
		mov r3,#0
@@move_loop:
		ldrb r2,[r0,r3]
		tst r2,#0x1
		beq @@move_iter ; If move does not exist, don't bother
		orr r2,r2,#0x4
		strb r2,[r0,r3]
@@move_iter:
		cmp r3,#24
		addlt r3,r3,#8
		blt @@move_loop
		b @@ret
@@ally_user:
		mov r1,#0
		ldr r0,[r4,#+0xb4]
		ldrb r2,[r0,#0x6]
		cmp r2,#0
		beq @@leader
		mov r1,#4
		; strb r1,[r0,#0x6]
		strb r1,[r0,#+0xa8] ; Personal tactic: all for one
		; mov r1,#4
		; strh r1,[r0,#+0xc]
		ldrb r1,[r0,#+0x9e]
		orr r1,r1,#0x80
		strb r1,[r0,#+0x9e]
		ldrb r1,[r0,#+0xa0]
		orr r1,r1,#0x1
		strb r1,[r0,#+0xa0]
		ldr r0,[r9,#+0xb4]
		ldrsh r1,[r0,#+0x12]
		ldrsh r0,[r0,#+0x16]
		add r0,r0,r1
		mov r1,#4
		bl EuclidianDivision
		mov r1,r0
		mov r0,r9
		mov r2,#0
		mov r3,#0
		str r2,[r13,#+0x0c]
		bl ConstDamage
		mov r0,#0
		mov r1,r9
		mov r2,#0
		bl ChangeString
		mov r0,#1
		mov r1,r4
		mov r2,#0
		bl ChangeString
		mov r0,r9
		ldr r1,=success
		bl SendMessageWithStringLog
		ldr r0,[r4,#+0xb4]
		mov r1,#0
		strb r1,[r0,#0x6] ; set as team member
		;mov r1,#1
		;strb r1,[r0,#0x8]
		;mov r1,#6
		;strh r1,[r0,#+0xc] ; change display name to Friend
		; Western Cave Mewtwo
		mov r1,#18
		ldr r2,=#41
		bl GetGameVarIndexed
		cmp r0,#1
		bne @@ret
		ldr r0,[r4,#+0xb4]
		ldrh r0,[r0,#+0x2]
		mov r1,#63
		cmp r0,r1
		addne r1,r1,#600
		cmpne r0,r1
		bne @@ret
		; Dialogue
		mov r0,#150
		mov r1,#14
		ldr r2,=abra	
; ExecDialogue(r0: pkmn_id, r1: face_id, r2: string_ptr)
    		stmdb r13!, {r4,r14}
    		sub r13,r13,#0x10; portrait structure is 0x10 bytes long
    		mov r4,r2
    		cmp r0,#0
    		moveq r1,#0
    		beq @@exec_diag
    		mov r2,r1
    		mov r1,r0
    		mov r0,r13
    		bl 0x0234BAC0
    		mov  r1,r13
@@exec_diag: ; Thanks Irdkwia :D
    		mov r2,r4
    		mov  r0,#0
    		mov  r3,#0x1
    		bl 0x0234D304
    		add r13,r13,#0x10
    		ldmia r13!, {r4,r14}
		; Skip to 99F
		ldr r0,=DungeonBaseStructPtr
		ldr r0,[r0]
		mov r1,#1
		strb r1,[r0,#+0x6]
		strb r1,[r0,#+0x8]
		mov r1,#99
		strb r1,[r0,#+0x749]
		; Set a flag for if this Abra Teleport happens!
		; SetGameVarIndexed(r0: buffer, r1: game_var_id, r2: index, r3: value): 0x0204B988
		mov r1,#18
		ldr r2,=#49
		mov r3,#1
		bl SetGameVarIndexed
		b @@ret
@@too_late:
		mov r0,#0
		mov r1,r4
		mov r2,#0
		bl ChangeString
		mov r0,r9
		ldr r1,=brainwash
		bl SendMessageWithStringLog
		b @@ret
@@leader:
		mov r0,#0
		mov r1,r4
		mov r2,#0
		bl ChangeString
		mov r0,r9
		ldr r1,=fail
		bl SendMessageWithStringLog
		b @@ret
@@low_hp:
		mov r0,#0
		mov r1,r9
		mov r2,#0
		bl ChangeString
		mov r0,r9
		ldr r1,=please
		bl SendMessageWithStringLog
@@ret:
		b MoveJumpAddress
		.pool
	fail:
		.asciiz "But [string:0] resisted!"
	success:
		.asciiz "[string:0] took control[R]of [string:1]!"
	brainwash:
		.asciiz "But [string:0] is already[R]on someone else's side!"
	abra:
		.asciiz "[STS][hero][STE]: [CS:G]Abra[CR],[W:20] use [CS:K]Teleport[CR]!"
	please:
		.asciiz "But [string:0] doesn't have enough HP!"
	.endarea
.close