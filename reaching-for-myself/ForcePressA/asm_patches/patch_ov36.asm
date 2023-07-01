.org 0x23A7080+0x30F70+0x820+0x38
.area 0x40

ButtonHook:
	push r0-r5,r12,r14
	mov r4,r0
	mov r5,r1
	mov r0,#0
	mov r1,#78
	mov r2,#63
	bl GetGameVarIndexed
	cmp r0,#0
	movne r4,#0x1
	strh r4,[r5] ; Original instruction, sorta
	pop r0-r5,r12,r14
	b EndButtonHook
.endarea
