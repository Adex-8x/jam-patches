.org 0x200B014
.area 0x4
	ldrb r2,[r4,#+0x0]
NoGrayscaleFlush:
.endarea

.org 0x0200ae84
.area 0x4
	ldrb r0,[r4,#0x1]
NoGrayscale:
.endarea

.org 0x0200ae90
.area 0x4
	and r0,r0,#0xf8
.endarea

; For a more permanent grayscale...
;.org 0x0200A73C
;.area 0x50
;	push r4-r7,r14
;	mov r7,r0
;	ldr r5,[r0,#+0x18]
;	ldr r6,[r0,#+0x1C]
;	mov r4,#0x0
;	b next_loop_iter
;palette_loop:
;	ldrb r1,[r5,#+0x1]
;	ldrb r2,[r5,#+0x2]
;	ldrb r0,[r5],#+0x4
;	add r0,r0,r1
;	add r0,r0,r2
;	mov r1,#3
;	bl ComputeGrayscaleHalfword
;	strh r0,[r6],#+0x2
;	add r4,r4,#0x1
;next_loop_iter:
;	ldr r1,[r7,#+0x4]
;	cmp r4,r1
;	blt palette_loop
;	mov r0,r7
;	pop r4-r7,r15
;.endarea

.org 0x0200bd8c
.area 0x4
	b GrayscaleFlush
.endarea

.org 0x0200bd90 ; case 0
.area 0x4
	b TurnOffGrayscale
.endarea

.org 0x0200bfb0
.area 0x4
	b 0x0200c000 ; original instruction
.endarea

.org 0x0200C000
.area 0x4
	add r13,r13,#0x4
.endarea

.org 0x0200ae78
.area 0x4
	bcc CheckGrayscaleHook
.endarea