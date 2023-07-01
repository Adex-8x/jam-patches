; ------------------------------------------------------------------------------
; Brainwash
; The target joins the user's side!
; ------------------------------------------------------------------------------

.relativeinclude on
.nds
.arm

.definelabel MaxSize, 0x2598

.definelabel FADE_IN, 0x4
.definelabel FADE_OUT, 0x5

; Uncomment/comment the following labels depending on your version.

; For US
.include "lib/stdlib_us.asm"
.include "lib/dunlib_us.asm"
.definelabel MoveStartAddress, 0x02330134
.definelabel MoveJumpAddress, 0x023326CC
.definelabel GetGameVarIndexed, 0x0204B678
.definelabel DungeonBaseStructPtr, 0x2353538
.definelabel HasLowHealth, 0x022FB610
.definelabel SetGameVar, 0x0204B820
.definelabel SetGameVarIndexed, 0x0204B988 
.definelabel StopMusic, 0x02019B28
.definelabel FadeInOutWhite, 0x0234C668

; For EU
;.include "lib/stdlib_eu.asm"
;.include "lib/dunlib_eu.asm"
;.definelabel MoveStartAddress, 0x02330B74
;.definelabel MoveJumpAddress, 0x0233310C

; File creation
.create "./code_out.bin", 0x02330134 ; For EU: 0x02330B74
	.org MoveStartAddress
	.area MaxSize

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
		mov r0,r9
		bl HasLowHealth
		cmp r0,#1
		beq @@low_hp
		ldr r0,[r9,#+0xb4]
		ldrsh r1,[r0,#+0x12]
		ldrsh r0,[r0,#+0x16]
		add r0,r0,r1
		lsr r1,r0,#2
		cmp r1,#0
		addeq r1,r1,#1
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
		mov r0,#0
		mov r1,#18
		mov r2,#208
		mov r3,#1
		bl SetGameVarIndexed
		ldr r0,[r4,#+0xb4]
		;mov r1,#1
		;strb r1,[r0,#0x6]
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
		ldrh r0,[r8,#+0x2]
		orr r0,r0,#0x1
		strh r0,[r8,#+0x2]
		b @@ret
@@ally_user:
		mov r0,#0
		bl StopMusic
		mov r0,#0
		bl #0x02019FE8
		ldr r0,=#498
		mov r1,#17
		ldr r2,=cheat1
		bl @@ExecDialogue
		ldr r0,=#498
		mov r1,#10
		ldr r2,=cheat2
		bl @@ExecDialogue
		mov r0,#0
		mov r1,#0
		mov r2,#0xCC
		bl SetGameVar
		mov r0,FADE_OUT
		mov r1,#0x1000 ; The higher the value, the faster the fade time!
		mov r2,#0x0
		bl FadeInOutWhite
		mov r0,FADE_OUT
		mov r1,#0x1000 ; The higher the value, the faster the fade time!
		mov r2,#0x1
		bl FadeInOutWhite
		ldr r0,=#6403
		mov r1,#0x100
		mov r2,#0x1F
		bl #0x0201A4FC
		mov r10,#0
@@fade_loop:
		mov r0,#0
		bl 0x22E9FE0
		cmp r10,#60
		addlt r10,r10,#1
		blt @@fade_loop
		; bl #0x22E0968
		mov r0,#0
		bl #0x02048F84
		mov r0,#0
		bl #0x2003D70
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
	success:
		.asciiz "[string:0] took control[R]of [string:1]!"
	cheat1:
		.asciiz "[STS][CS:N]Finneon[CR][M:T0][STE] Stop![K] Are you actually...[K][R]Trying to cheat?[C][STS][CS:N]Finneon[CR][M:T0][STE] Didn't you think I would notice you[R]messing around with your moves?"
	cheat2:
		.asciiz "[STS][CS:N]Finneon[CR][M:T0][STE] You know...[K][R][VS:1:4]I actually [W:15]LOVE[W:15] cheaters![VR][C][STS][CS:N]Finneon[CR][M:T0][STE] You deserve something [W:15][VS:1:5]special![VR][K][R]Please accept my heartfelt gratitude!"
	please:
		.asciiz "But [string:0] doesn't have enough HP!"
	.endarea
.close