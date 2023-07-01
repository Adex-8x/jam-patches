.org 0x023A7080+0x30F70+0x450+0xB0+0x38+0x150
.area 0x110

; idk
;GrayscaleFlushHook:
;	mov r0,#0
;	mov r1,#1
;	bl GetGameVar
;	cmp r0,#0
;	ldreqb r2,[r4,#+0x0]
;	beq NoGrayscaleFlush
;	bl ComputeGrayscaleByte
;	str r0,[r13,#+0xC]
;	str r0,[r13,#+0x10]
;	strb r0,[r4,#+0x0]
;	strb r0,[r4,#+0x1]
;	strb r0,[r4,#+0x2]
;	b #0x0200b054

;GrayscaleHook:
;	mov r0,#0
;	mov r1,#1
;	push r3
;	bl GetGameVar
;	pop r3
;	cmp r0,#0
;	ldreqb r0,[r4,#0x1]
;	beq NoGrayscale
;	bl ComputeGrayscaleByte
;	mov r1,r0
;	mov r2,r0
;	add r4,r4,#0x4
;	b #0x0200ae90

;ComputeGrayscaleByte:
;	push r3,r14
;	ldrb r0,[r4,#+0x0]
;	ldrb r1,[r4,#+0x1]
;	ldrb r2,[r4,#+0x2]
;	add r0,r0,r1
;	add r0,r0,r2
;	mov r1,#3
;	bl EuclidianDivision
;	pop r3,r15

;ComputeGrayscaleHalfword:
;	push r14
;	bl EuclidianDivision
;	and r1,r0,#0xF8
;	and r2,r0,#0xF8
;	mov r1,r1,lsl #0x2
;	and r0,r0,#0xF8
;	orr r1,r1,r2,lsl #0x7
;	orr r0,r1,r0, asr #0x3
;	pop r15

;SaveFlushHook:
;	push r0,r14
;	strh r0,[r11,#0x0]
;	cmp r9,#7
;	popne r0,r15
;	mov r2,r0
;	mov r0,#0
;	mov r1,#1
;	bl 0x0204B820
;	pop r0,r15

;SaveColorBytesHook:
;	push r0-r8,r10,r11,r14
;	ldr r4,=FLUSH_COLORS
;	strb r8,[r4]
;	strb r6,[r4,#+0x1]
;	strb r7,[r4,#+0x2]
;	mov r5,#2
;color_loop:
;	mov r0,#0
;	mov r1,#88
;	mov r2,r5
;	ldrb r3,[r4,r5]
;	bl 0x0204B988
;	subs r5,r5,#1
;	bpl color_loop
;	mov r9,#0
;	pop r0-r8,r10,r11,r15


CheckGrayscaleHook:
	ldr r12,[GRAY_FLAG]
	cmp r12,#0
	beq 0x0200AEC0 ; regular flush out
	; This is where the fun begins...
	mov r9,#0
	b grayscale_loop_next_iter
grayscale_loop:
	ldrb r0,[r4,#+0x0]
	ldrb r1,[r4,#+0x1]
	ldrb r2,[r4,#+0x2]
	add r0,r0,r1
	add r0,r0,r2
	mov r1,#3
	bl EuclidianDivision
	mov r6,r0 ; Equal grayscale byte!
	ldr r7,=GRAY_BYTES
	mov r8,#2
calculate_gray_differences:
	ldrb r11,[r4,r8]
	sub r0,r11,r6
	bl 0x208655C ; Abs
	ldrh r1,[r10,#+0xA]
	mov r2,#0xFF
	sub r1,r2,r1
	bl 0x02001B0C ; UMultByFP
	ldrb r1,[r4,r8]
	cmp r1,r6 ; Compare current byte to grayscale
	subgt r0,r1,r0
	addle r0,r1,r0
	strb r0,[r7,r8]
	subs r8,r8,#1
	bpl calculate_gray_differences
	; Calculate halfword
	ldrb r1,[r7,#+0x1]
	ldrb r2,[r7,#+0x2]
	ldrb r3,[r7]
	and r1,r1,#0xF8
	and r2,r2,#0xF8
	lsl r1,r1,#0x2
	and r3,r3,#0xF8
	orr r1,r1,r2, lsl #0x7
	orr r1,r1,r3, asr #0x3
	add r4,r4,#0x4
	strh r1,[r5],#0x2
	add r9,r9,#0x1
grayscale_loop_next_iter:
	ldr r0,[r10,#+0x4]
	cmp r9,r0
	blt grayscale_loop
	b 0x0200B0A4

TurnOffGrayscale:
	mov r12,#0
	str r12,[GRAY_FLAG]
	b 0x0200C000
;return_no_flag_set:
;	add r13,r13,#0x4
;	pop r3,r4,r15

GrayscaleFlush:
	mov r3,#1
	str r3,[GRAY_FLAG]
	ldrsh r1,[r4,#+0x14]
	add r0,r4,#0x1C
	add r2,r4,#0x16
	rsb r1,r1,#0x100
	lsl r1,r1,#0x10
	lsr r1,r1,#0x10
	bl 0x0200A410
	b 0x0200c000

.pool
GRAY_FLAG:
	.word 0x0
GRAY_BYTES:
	.byte 0x0, 0x0, 0x0
.endarea
