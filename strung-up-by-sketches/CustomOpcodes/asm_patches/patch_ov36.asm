.org 0x023A7080+0x30F70
.area 0x450

; =================================
; Cutscene Skipping
; =================================

ExecuteActingHook:
	push r1,r14
	ldr r0,=CutsceneSkipByte
	ldrb r0,[r0]
	cmp r0,#1
	ldreq r1,=cancel_address
	ldreq r0,[r4,#+0x1C]
	streq r0,[r1]
acting_ret:
	ldrh r0,[r6] ; Original instruction
	pop r1,r15

CancelCutHook:
	push r1,r14
	ldr r1,=cancel_address
	mov r0,#0 ; Original instruction
	str r0,[r1]
	pop r1,r15

; =================================
; Letterboxes
; =================================

LowerBoxTransitionHook:
	ldr r3,=LOWER_BLACK_BOX_ID
	ldr r3,[r3]
	cmp r8,r3
	bne store_starting_y_pos
	ldr r3,=SHOW_BLACK_BOX_FLAG
	ldrb r12,[r3]
	cmp r12,#0
	beq check_lower_hide_flag
	ldr r3,=LOWER_BLACK_BOX_COUNTER
	ldrh r12,[r3]
	cmp r12,r1
	subgt r12,r12,#3
	strgth r12,[r3]
	movgt r1,r12
	b store_starting_y_pos
check_lower_hide_flag:
	ldrb r12,[r3,#+0x1]
	cmp r12,#0
	beq store_starting_y_pos
	ldr r3,=LOWER_BLACK_BOX_COUNTER
	ldrh r12,[r3]
	cmp r12,#0xC0
	addle r12,r12,#3
	strleh r12,[r3]
	mov r1,r12
store_starting_y_pos:
	ldr r3,=UPPER_BLACK_BOX_ID
	ldr r3,[r3]
	cmp r8,r3
	moveq r1,#0 ; This is the jankiest thing I've ever written but who cares
	strh r1,[r0,#+0x6] ; Original instruction
	bx r14

UpperBoxTransitionHook:
	ldr r3,=UPPER_BLACK_BOX_ID
	ldr r3,[r3]
	cmp r8,r3
	bne store_ending_y_pos
	ldr r3,=SHOW_BLACK_BOX_FLAG
	ldrb r12,[r3]
	cmp r12,#0
	beq check_upper_hide_flag
	ldr r3,=UPPER_BLACK_BOX_COUNTER
	ldrh r12,[r3]
	cmp r12,r1
	addlt r12,r12,#2
	strlth r12,[r3]
	movlt r1,r12
	b store_ending_y_pos
check_upper_hide_flag:
	ldrb r12,[r3,#+0x1]
	cmp r12,#0
	beq store_ending_y_pos
	ldr r3,=UPPER_BLACK_BOX_COUNTER
	ldrh r12,[r3]
	cmp r12,#0
	subgt r12,r12,#2
	strgth r12,[r3]
	mov r1,r12
store_ending_y_pos:
	strh r1,[r0,#+0xA] ; Original instruction
	bx r14

NextDBoxIterHook:
	add r7,r5,r6, lsl #0x7 ; Original instruction
	mov r0,#0xA00
	mov r1,#0x60
	mla r0,r1,r6,r0
	add r8,r7,r0 ; This is so cursed
	ldr r0,=CANVAS_STRUCTS
	sub r8,r8,r0
	lsr r8,r8,#0x7 ; ????? I wrote this and forgor why it worked
	bx r14

IsCurrentDBoxSpecial:
	push r1-r2,r14
	ldr r2,=LOWER_BLACK_BOX_ID
	ldr r1,[r2]
	ldr r2,[r2,#+0x4]
	cmp r8,r1
	cmpne r8,r2
	movne r12,#0
	moveq r12,#1
	pop r1-r2,r15

UpdateFrameHook:
	push r14
	bl IsCurrentDBoxSpecial
	cmp r12,#1
	popeq r15
	bl UpdateFrameStruct
	pop r15

DBoxColorHook:
	push r14
	bl IsCurrentDBoxSpecial
	cmp r12,#1
	moveq r1,#0
	strh r1,[r0,#+0x1A] ; Original instruction
	pop r15

; =================================
; Opcodes
; =================================

NewOpcodeParameterHook:
	ldr r7,=#11621 ; Very funny, yes I know
	cmp r5,r7
	ldrge r0,=NEW_SCRIPT_OPCODES_PARAM_COUNT
	subge r1,r5,r7
	ldrsb r0,[r0,r1]
	bx r14

NewOpcodesHook:
	cmp r5,r7
	bge NewOpcodes
	cmp r5,r0
	b EndHook
NewOpcodes:
	sub r5,r5,r7
	cmp r5,#0x9
	addls r15,r15,r5,lsl #0x2
	; r7-r11 are free!
	b ReturnTwo
	b RestoreAddress
	b CheckInputStatus
	b SetTextboxAttribute
	b ChangeTextboxColor
	b CreateLetterboxes
	b HideLetterboxes
	b FreeLetterboxes
	b DeleteLetterboxes

RestoreAddress:
	ldr r1,=cancel_address
	ldr r0,[r1]
	cmp r0,#0
	strne r0,[r4,#+0x1C]
	b ReturnTwo

CheckInputStatus:
	sub r13,r13,#0x4
	ldrh r0,[r6]
	cmp r0,#0
	ldreq r2,=CheckPressInput
	ldrne r2,=CheckHeldInput
	mov r0,#0
	mov r1,r13
	blx r2
	mov r0,#0
	mov r1,#92 ; $EVENT_LOCAL
	ldrh r2,[r13]
	bl SetGameVar
	add r13,r13,#0x4
	b ReturnTwo

SetTextboxAttribute:
	mov r7,#0
	ldr r8,=MESSAGE_TALK_FORMAT
	add r8,r8,#0x4 ; We don't want to touch the update function!
textbox_param_loop:
	ldrh r0,[r6,r7]
	strb r0,[r8],#0x1
	cmp r7,#0xA
	addlt r7,r7,#2
	blt textbox_param_loop
	b ReturnTwo

ChangeTextboxColor:
	mov r7,#0
	ldr r8,=TextboxColors
color_param_loop:
	ldrh r0,[r6,r7]
	strb r0,[r8],#+0x1
	cmp r7,#0x6
	addlt r7,r7,#2
	blt color_param_loop
	b ReturnTwo

CreateLetterboxes:
	ldr r0,=LOWER_BLACK_BOX_COUNTER
	mov r1,#0xC0
	strh r1,[r0]
	mov r1,#0x0
	strh r1,[r0,#+0x2]

	ldr r1,=SHOW_BLACK_BOX_FLAG
	mov r0,#1
	strb r0,[r1]
	mov r0,#0
	strb r0,[r1,#+0x1]

	ldr r0,=LOWER_BLACK_BOX_FORMAT
	mov r1,#0
	mov r2,r1
	ldr r3,=#299
	bl CreateInstantDBox
	ldr r1,=LOWER_BLACK_BOX_ID
	str r0,[r1]

	ldr r0,=UPPER_BLACK_BOX_FORMAT
	mov r1,#0
	mov r2,r1
	ldr r3,=#299
	bl CreateInstantDBox
	ldr r1,=UPPER_BLACK_BOX_ID
	str r0,[r1]
	b ReturnTwo

HideLetterboxes:
	ldr r1,=HIDE_BLACK_BOX_FLAG
	mov r0,#1
	strb r0,[r1]
	mov r0,#0
	strb r0,[r1,#-0x1]
	b ReturnTwo

FreeLetterboxes:
	ldr r7,=LOWER_BLACK_BOX_ID
	ldr r0,[r7]
	cmp r0,#0xFF
	beq try_free_upper
	bl FreeInstantDBox
try_free_upper:
	ldr r0,[r7,#+0x4]
	cmp r0,#0xFF
	beq ReturnTwo
	bl FreeInstantDBox
	b ReturnTwo

DeleteLetterboxes:
	ldr r7,=LOWER_BLACK_BOX_ID
	mov r0,#0xFF
	str r0,[r7]
	str r0,[r7,#+0x4]
	b ReturnTwo

.pool
NEW_SCRIPT_OPCODES_PARAM_COUNT:
	.byte 0x0, 0x1, 0x6, 0x4, 0x0, 0x0, 0x0, 0x0
.align
LOWER_BLACK_BOX_FORMAT:
	; Function to update stuff
	.byte 0x10 ;0x88
	.byte 0xFF ;0xF4
	.byte 0x02
	.byte 0x02
	.byte 0x0 ; X offset
	.byte 0x12 ; Y offset
	.byte 0x20 ; Width
	.byte 0x7 ; Height
	.byte 0x0 ; Screen
	.byte 0xFC ; Frame Type (0xFA for blank)
	.fill 0x6, 0x0
.align
UPPER_BLACK_BOX_FORMAT:
	; Function to update stuff
	.byte 0x10 ;0x88
	.byte 0xFF ;0xF4
	.byte 0x02
	.byte 0x02
	.byte 0x0 ; X offset
	.byte 0x1 ; Y offset--DO NOT UNDER ANY CIRCUMSTANCES MAKE THIS 0, IT WILL CAUSE ISSUES!!!!
	.byte 0x20 ; Width
	.byte 0x4 ; Height
	.byte 0x0 ; Screen
	.byte 0xFC ; Frame Type (0xFA for blank)
	.fill 0x6, 0x0
.align
cancel_address:
	.word 0x0
LOWER_BLACK_BOX_ID:
	.word 0xFF
UPPER_BLACK_BOX_ID:
	.word 0xFF
SHOW_BLACK_BOX_FLAG:
	.byte 0x0
HIDE_BLACK_BOX_FLAG:
	.byte 0x0
LOWER_BLACK_BOX_COUNTER:
	.halfword 0xC0
UPPER_BLACK_BOX_COUNTER:
	.halfword 0x0
.align
.endarea
