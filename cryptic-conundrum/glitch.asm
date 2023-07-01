; ------------------------------------------------------------------------------
; Glitch
; Has various effects!
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
.definelabel BasePointer, 0x020AF6B8
.definelabel GetItemPosition, 0x0200D278
.definelabel GetGameVarIndexed, 0x0204B678
.definelabel RNG, 0x22EAA98
.definelabel Warp, 0x02320D08

; For EU
;.include "lib/stdlib_eu.asm"
;.include "lib/dunlib_eu.asm"
;.definelabel MoveStartAddress, 0x02330B74
;.definelabel MoveJumpAddress, 0x0233310C
;.definelabel BasePointer, 0x020AFF70

; File creation
.create "./code_out.bin", 0x02330134 ; For EU: 0x02330B74
	.org MoveStartAddress
	.area MaxSize
		
		push r5,r7,r10,r12
		sub r13,r13,#0x8
		ldr r0,[r4,#+0xb4]
		ldrsh r5,[r0,#+0x10]
		ldrb r0,[r0,#+0xd0]
		cmp r0,#0
		moveq r3,#0x100
		moveq r10,#0
		movne r3,#0xCC ; Is confused, lower damage ratio
		movne r10,#1
		mov r0,r9
		mov r1,r4
		mov r2,r8
		bl DealDamage
		cmp r0,#0
		beq @@ret
		cmp r0,r5
		bge @@ret
		; 128 of the sixth item!
		ldr r5,=BasePointer
		ldr r5,[r5]
		ldr r5,[r5,#+0x384]
		add r0,r5,#30
		ldrh r1,[r0,#+0x4]
		ldrh r2,[r0,#+0x2]
		cmp r1,#0
		cmpne r2,#0
		beq @@fun_part
		mov r1,#128
		strh r1,[r0,#+0x2]
@@fun_part:
		bl NameCheck
		cmp r0,#0
		beq @@no_match
@@reviser_check:
		mov r0,#105 ; To turn into 73 later!
		bl GetItemPosition
		cmp r0,#0
		blt @@no_reviser_but_match
		cmp r0,#0x8000
		bge @@storage_reviser
		mov r1,#6
		mla r0,r0,r1,r5
		mov r1,#73
		strh r1,[r0,#+0x4]
		mov r0,r9
		ldr r1,=all_match
		bl SendMessageWithStringLog
		b @@final_effect
@@no_match:
		mov r0,r9
		ldr r1,=no_match
		bl SendMessageWithStringLog
		b @@final_effect
@@storage_reviser:
		mov r0,r9
		ldr r1,=storage_reviser
		bl SendMessageWithStringLog
		b @@final_effect
@@no_reviser_but_match:
		mov r0,r9
		ldr r1,=no_reviser_but_match
		bl SendMessageWithStringLog
@@final_effect:
		mov r0,#3
		bl RNG
		cmp r0,#0
		beq @@warp
		; Confuse(r0: User, r1: Target, r2: FailMessage, r3: OnlyCheck)
		cmp r10,#1
		beq @@stat_drop_chance
		mov r0,r9
		mov r1,r4
		mov r2,#1
		mov r3,#0
		bl Confuse
		b @@ret
@@warp:
		mov r0,r9
		mov r1,r4
		mov r2,#0
		mov r3,#0
		bl Warp
		b @@ret
@@stat_drop_chance:
		mov r0,#7
		bl RNG ; 0 = AtkDown, 1 = SpAtkDown, 2 = DefDown, 3 = SpDefDown, 4 = AccDown, 5 = EvDown, 6 = SpeedDown
		cmp r0,#6
		bne @@not_speed
		mov r0,r9
		mov r1,r4
		mov r2,#1
		mov r3,#4
		bl SpeedStatDown
		b @@ret
@@not_speed:
		mov r12,r0
		mov r0,r9
		mov r1,r4
		mov r2,#0
		mov r3,#1
		str r2,[r13]
		str r2,[r13,#+0x4]
		ldr r7,=stat_func_list
		ldr r7,[r7,r12, lsl #0x2]
		tst r12,#0x1
		moveq r2,#0
		movne r2,#1
		blx r7
@@ret:
		add r13,r13,#0x8
		pop r5,r7,r10,r12
		b MoveJumpAddress
NameCheck:
		push r14
		mov r7,#0
name_loop:
		cmp r7,#2
		cmpne r7,#4
		cmpne r7,#6
		bne next_char_iter
		mov r0,#0
		mov r1,#63
		mov r2,r7
		bl GetGameVarIndexed
		ldr r1,=list
comparison_loop:
		ldrb r2,[r1],#+0x1
		cmp r2,#0
		beq comparison_break
		cmp r0,r2
		bne comparison_loop
comparison_break:
		cmp r2,#0
		movne r0,r2
		popne r15
next_char_iter:
		cmp r7,#0x9
		addlt r7,r7,#0x1
		blt name_loop
		mov r0,#0
		pop r15
		.pool
	all_match:
		.asciiz "[FT:1]A#WINNER#IS#YOU![FT:0][R][FT:1]CHECK#THE#SYSTEM#FOLDER[R][FT:1]FOR#MORE#INFORMATION![FT:0]"
	storage_reviser:
		.asciiz "[FT:1]THE#DEVICE#INSERTED#IN[FT:0][R][FT:1]SLOT#A#CANNOT#BE#USED![FT:0]"
	no_match:
		.asciiz "[FT:1]STOP#POSTING#ABOUT#CTC![FT:0][R][FT:1]I'M#TIRED#OF#SEEING#IT![FT:0]"
	no_reviser_but_match:
		.asciiz "[FT:1]COME#BACK#WHEN#YOU'RE[FT:0][R][FT:1]A#LITTLE#RICHER![FT:0]"
	.align
	stat_func_list:
		.word AttackStatDown, AttackStatDown, DefenseStatDown, DefenseStatDown, FocusStatDown, FocusStatDown
	list:
		.byte 0x47, 0x48, 0x4A, 0x4D, 0x53, 0x54, 0x61, 0x62, 0x63, 0x6D, 0x6F, 0x70, 0x78, 0x77, 0x78, 0x79, 0x0
	.endarea
.close
