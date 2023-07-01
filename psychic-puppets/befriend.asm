; ------------------------------------------------------------------------------
; Befriend
; Once used, the user can recruit the target!
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
.definelabel SetupRecruitStruct, 0x22f9058
.definelabel RecruitTarget, 0x230E064
.definelabel SearchAssemblySlot, 0x2055964
.definelabel DungeonBaseStructPtr, 0x2353538
.definelabel SetGameVarIndexed, 0x0204B988
.definelabel AssemblyPointer, 0x20B0A48
.definelabel Warp, 0x02320D08

; For EU
;.include "lib/stdlib_eu.asm"
;.include "lib/dunlib_eu.asm"
;.definelabel MoveStartAddress, 0x02330B74
;.definelabel MoveJumpAddress, 0x0233310C

; File creation
.create "./code_out.bin", 0x02330134 ; For EU: 0x02330B74
	.org MoveStartAddress
	.area MaxSize

		ldr r0,[r4,#+0xb4]
		ldrb r0,[r0,#0x6]
		cmp r0,#0
		beq @@fail
		ldr r0,=DungeonBaseStructPtr
		ldr r0,[r0]	
		ldrb r0,[r0,0x748]
		cmp r0,#1
		beq @@final_boss
		mov r1,#18
		ldr r2,=#42
		bl GetGameVarIndexed
		cmp r0,#1
		beq @@fail
		bl SearchAssemblySlot
		cmp r0,#0
		beq @@too_many_friends
		sub r13,r13,#0x240
		mov r0,r13
		mov r1,r4
		bl SetupRecruitStruct
		mov r0,r9
		mov r1,r4
		mov r2,r13
		bl RecruitTarget
		add r13,r13,#0x240
		cmp r0,#0
		bne @@ret
		; If equal, then recruitment has failed!
		mov r0,r9
		mov r1,r4
		mov r2,#0
		mov r3,#0
		bl Warp
		;ldrb r0,[r8,#+0x6]
		;add r0,r0,#1
		;strb r0,[r8,#+0x6]
		b @@ret
@@final_boss:
		; Pacifism check
		ldr r0,[r4,#+0xb4]
		ldrh r0,[r0,#+0x2] ; Species
		mov r1,#150
		cmp r0,r1
		addne r1,r1,#600 ; If the player is stupid and set Mewtwo to Invalid
		cmpne r0,r1
		bne @@fail
		; This is where the fun begins
		mov r1,#18
		mov r2,#40
		bl GetGameVarIndexed
		cmp r0,#0
		bne @@just_attack
		ldr r0,[r9,#+0xb4]
		ldrh r0,[r0,#+0x2]
		mov r1,#8
		ldr r2,=pacifism_part1
		bl @@ExecDialogue
		mov r0,#150
		mov r1,#17
		ldr r2,=pacifism_part2
		bl @@ExecDialogue
		; r0: CanInflict = Pause(r0: User, r1: Target, r2: ???, r3: NbTurns, [r13]: FailMessage, [r13+0x4]: OnlyCheck)
		mov r0,r9
		mov r1,r4
		mov r2,#0
		mov r3,#4
		sub r13,r13,#8
		str r2,[r13]
		str r2,[r13,#+0x4]
		bl Pause
		add r13,r13,#8
		; r0 = SetGameVarIndexed(r0: buffer, r1: game_var_id, r2: index, r3: value)
		mov r0,#0 ; Just in case? Null 
		mov r1,#18
		mov r2,#40
		mov r3,#1
		bl SetGameVarIndexed
		; Implement spooky save byte thingy here
		ldr r0,=AssemblyPointer
		ldr r0,[r0]
		mov r2,#2
		add r0,r0,#0x9300
    		add r0,r0,#0x6C
		mov r1,#0x1A0
    		mla r0,r2,r1,r0
		mov r2,#2
		mov r1,#0x68
		mla r0,r2,r1,r0
		add r0,r0,#0x5e
		mov r1,#65
		strb r1,[r0,#+0x3]
		b @@ret
@@just_attack:
		ldr r0,[r9,#+0xb4]
		ldrh r0,[r0,#+0x2]
		mov r1,#17
		ldr r2,=already_pacified
		bl @@ExecDialogue
		b @@ret
@@fail:
		mov r0,#0
		mov r1,r4
		mov r2,#0
		bl ChangeString
		mov r0,r9
		ldr r1,=fail
		bl SendMessageWithStringLog
		b @@ret
@@too_many_friends:
		ldr r0,[r9,#+0xb4]
		ldrh r0,[r0,#+0x2]
		mov r1,#4
		ldr r2,=friend_limit
		bl @@ExecDialogue
		ldrb r0,[r8,#+0x6]
		add r0,r0,#1
		strb r0,[r8,#+0x6]
@@ret:
		b MoveJumpAddress

@@ExecDialogue: ;ExecDialogue(r0: pkmn_id, r1: face_id, r2: string_ptr)
    stmdb r13!, {r4,r14}
    sub r13,r13,#0x10; portrait structure is 0x10 bytes long
    mov r4,r2
    cmp r0,#0
    moveq r1,#0
    beq exec_diag
    mov r2,r1
    mov r1,r0
    mov r0,r13
    bl 0x0234BAC0
    mov  r1,r13
exec_diag:
    mov r2,r4
    mov  r0,#0
    mov  r3,#0x1
    bl 0x0234D304
    add r13,r13,#0x10
    ldmia r13!, {r4,r15}
		.pool
	fail:
		.asciiz "But [string:0] resisted!"
	friend_limit:
		.asciiz "[STS][hero][M:T0][STE] I'm...[K]starting to feel like[R]I'm compensating for something...[C][STS][hero][STE]: Maybe I shouldn't add them[R]to the main party..."
	pacifism_part1:
		.asciiz "[STS][hero][M:T0][STE] [partner]...[K]listen...![C][STS][hero][M:T0][STE] You don't have to do this...![K][R]Please stop...!"
	pacifism_part2:
		.asciiz "[STS][partner][M:T0][STE] .[W:20].[W:20].[W:20]"
	already_pacified:
		.asciiz "(It looks like they aren't budging...)[C](I...[K]guess I have to...[K]have to...)"
	.endarea
.close