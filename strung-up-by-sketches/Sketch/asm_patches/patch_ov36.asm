.org 0x023A7080+0x30F70+0x450+0xB0+0x38+0x150+0x110
.area 0x3A0

MoveMenuHook:
	ldr r1,=SKETCH_FLAG
	ldr r1,[r1]
	cmp r1,#0
	beq EndMoveMenuHook
	ldrb r1,[r2,#+0x6]
	cmp r1,#5
	movgt r1,#5
	strgtb r1,[r2,#+0x6] ; Display the PP properly!
	mov r1,#0 ; Original instruction
	b EndMoveMenuHook

AdjustPPHook:
	bl SomeInitMoveWrapper
	mov r0,r13
	add r0,r0,r4,lsl #0x3
	bl GetBasePP
	cmp r0,#5
	movgt r1,r13
	addgt r1,r1,r4,lsl #0x3
	movgt r0,#5
	strgtb r0,[r1,#+0x6]
	b EndPPHook

SelectHook:
	push r4-r12,r14
	sub r13,r13,#0x8
	; First check if the leader is Smeargle...
	mov r11,#0
	bl GetLeader
	mov r4,r0
	bl GetTileAtEntity
	mov r10,r0
	ldr r5,[r4,#+0xB4]
	ldrh r0,[r5,#+0x2]
	ldr r1,=#1137 ; Female Smeargle
	cmp r0,r1
	bne sketch_ret
	; Check for a valid target in front!
	ldr r2,=DIRECTIONS_XY
	add r3,r2,#2
	ldrb r0,[r5,#+0x4C]
	lsl r0,r0,#2
	ldrsh r1,[r3,r0]
	ldrsh r0,[r2,r0]
	ldrh r2,[r4,#+0x4]
	ldrh r3,[r4,#+0x6]
	add r0,r0,r2
	add r1,r1,r3
	mov r6,r0
	mov r8,r1
	bl PosIsOutOfBounds
	cmp r0,#0
	bne sketch_ret
	mov r0,r6
	mov r1,r8
	bl GetTile
	ldr r0,[r0,#+0xC]
	mov r6,r0
	bl EntityIsValid
	cmp r0,#0
	beq sketch_ret
	; If at this point, r6 holds the target entity to check.
	ldr r7,[r6,#+0xB4]
	ldrb r0,[r7,#+0x6]
	ldrb r1,[r7,#+0x8]
	cmp r0,#1
	cmpeq r1,#0
	bne sketch_ret
	; The target is not an ally, cool...
	ldrsh r0,[r7,#+0x2]
	bl HasMonsterBeenIdentified
	cmp r0,#0
	beq unidentified_target
	ldr r2,=MOVES_TO_CHOOSE_FROM
	mov r0,#0
	str r0,[r2]
	str r0,[r2,#+0x4]
	; Time to go through the target's moves!
	add r3,r7,#0x124
	mov r8,#0 ; Move Counter
	mov r12,#0 ; Loop Counter
move_loop:
	ldrb r1,[r3]
	tst r1,#0x1
	beq move_next_iter
	mov r0,r3
	bl GetBasePPCustom
	ldrb r1,[r3,#+0x6]
	cmp r1,r0
	lsllt r0,r8,#0x1
	ldrlth r1,[r3,#+0x4]
	strlth r1,[r2,r0] ; Add a move to the list of moves to pull from!
	addlt r8,r8,#1
move_next_iter:
	cmp r12,#3
	addlt r12,r12,#0x1
	addlt r3,r3,#0x8
	blt move_loop
	; Done with the loop, now what?
	cmp r8,#0
	beq no_valid_moves
	; bye bye textbox
	mov r0,#1
    ldr r1,=0x023537CC
    ldr r1,[r1,#+0x4]
    add r1,r1,#0xC90
    str r0,[r1]
	; Hides map
	;bl 0x0234d558 ; idk???
	mov r0,#5
    mov r1,#0
    bl 0x022EA428
	; DisplayMessage method
	mov r0,#0xA
	;bl 0x0234ba54
	bl 0x0234d558
	; Irdkwia's method
	;mov r0,#6
	;mov r1,#0
	;bl 0x022EA428
	;mov r0,#0
	;bl 0x0233A248
	; Oh boy, very fun menu stuff
create_sketch_menu:
	bl PatiencePlease
	str r8,[r13]
	str r8,[r13,#+0x4]
	ldr r0,=MOVE_MENU_LAYOUT
	ldr r1,=0b1100000010011
	ldr r2,=MENU_INFO_PTR
	ldr r3,=MenuFunction
	bl CreateAdvancedMenu
	mov r9,r0
wait_loop:
	mov r0,#0x42
	bl WaitOneFrame
	mov r0,r9
	bl IsAdvancedMenuActive
	cmp r0,#0
	bne wait_loop
	; Close the menu!
	mov r0,r9
	bl GetAdvancedMenuResult
	mov r10,r0
	mov r0,r9
	bl FreeAdvancedMenu
	cmp r10,#0
	blt menu_ret
	ldr r0,=SKETCH_FLAG
	mov r1,#1
	str r1,[r0]
	; Moment of truth, it's move time!
	ldr r1,=MOVES_TO_CHOOSE_FROM
	lsl r10,r10,#0x1
	ldrh r1,[r1,r10]
	mov r0,r4
	bl TeachMoveMenu
	cmp r0,#0
	beq create_sketch_menu
	mov r11,#1
menu_ret:
	; bl 0x0234d558 ; help
	; Show map
	;mov r0,#0xB
	;mov r1,#0
	;bl 0x022EA428
	;bl UpdateMinimap
	bl PatiencePlease
	mov r0,#0x0
	mov r1,#0
	bl 0x022EA428
	b sketch_ret
unidentified_target:
	mov r0,r4
	ldr r1,=#296
	bl SendMessageWithIDCheckULog
	b sketch_ret
no_valid_moves:
	mov r0,r4
	ldr r1,=#297
	bl SendMessageWithIDCheckULog
	b sketch_ret
sketch_ret:
	ldr r0,=SKETCH_FLAG
	mov r1,#0
	str r1,[r0]
	bl PatiencePlease
	cmp r11,#1
	add r13,r13,#0x8
	pop r4-r12,r15


GetBasePPCustom:
	push r1-r4,r12,r14
	mov r4,r0
	; First, let's also check for a duplicate!
	bl GetLeader
	; No validity check; that was done already...
	ldr r0,[r0,#+0xB4]
	add r0,r0,#0x124
	ldrh r2,[r4,#+0x4]
	mov r12,#0
dupe_loop:
	ldrb r1,[r0]
	tst r1,#0x1
	beq dupe_loop_next_iter
	ldrh r1,[r0,#+0x4]
	cmp r1,r2
	moveq r0,#0 ; Base PP will never be less than 0
	beq dupe_ret
dupe_loop_next_iter:
	cmp r12,#3
	addlt r12,r12,#0x1
	addlt r0,r0,#0x8
	blt dupe_loop
	; No move dupes--get the base PP!
	mov r0,r4
	bl GetBasePP
dupe_ret:
	pop r1-r4,r12,r15

PatiencePlease:
	push r0-r12,r14
	mov r10,#2
wait_ret_loop:
	mov r0,#0x42
	bl WaitOneFrame
	subs r10,r10,#1
	bne wait_ret_loop
	pop r0-r12,r15

MenuFunction:
	push r4,r14
	sub r13,r13,#0x10
	mov r4,r0
	ldr r2,=MOVES_TO_CHOOSE_FROM
	lsl r1,r1,#0x1
	ldrh r1,[r2,r1]
	mov r0,r13
	bl InitMove
	mov r0,r4
	mov r1,r13
	mov r2,#0
	bl FormatMoveString
	mov r0,r4
	add r13,r13,#0x10
	pop r4,r15
.pool
MOVES_TO_CHOOSE_FROM:
	.halfword 0x0, 0x0, 0x0, 0x0
MENU_INFO_PTR:
        .word 0x0000000D
        .word 0x00000000
        .word 0x12A
        .word 0x00000010
MOVE_MENU_LAYOUT:
	.word 0x0202BD64 ; Function to update stuff
	.byte 0x2 ; X offset
	.byte 0x2 ; Y offset
	.byte 0x0 ; Width
	.byte 0x0 ; Height
	.byte 0x0 ; Screen
	.byte 0xFF ; Frame Type?
	.fill 0x6, 0x0 ; idk, but this is fine
.align ; It's probably aligned but idc
SKETCH_FLAG:
	.word 0x0
.endarea

; 0b1100000010111
;00 = A-Accept
;01 = B-Cancel (+screen button)
;02 = Accept Button
;03 = Up/Down Buttons
;04 = SE ON
;05 = Unknown
;06 = Unknown
;07 = Unknown
;08 = Unknown
;09 = Broken First Choice
;10 = Broken Menu
;11 = Menu Title
;12 = Menu Lower Bar
;13 = List Button
;14 = Search Button
;15 = Unknown
;16 = 
;17 = 
;18 = 
;19 = 
;20 = Y Pos End
;21 = X Pos End
;22 = Partial Menu
;23 = No Cursor
;24
;25
;26
;27
;28
;29
;30
;31